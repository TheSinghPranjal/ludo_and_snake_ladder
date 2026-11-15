# Dice Party LAN Protocol

Version 1. WebSocket on TCP 47821 by default, one JSON message per text frame. The host is authoritative: only it runs the engine and rolls dice.

## 1. Envelope

```json
{ "v": 1, "game": "snakes", "type": "Intent", "seq": 12, "data": {} }
```

| Field | Rule |
|---|---|
| `v` | Protocol version. Must equal 1, otherwise `version_mismatch`. |
| `game` | `snakes` or `ludo`. Must equal the room's game, otherwise `wrong_game`. |
| `type` | One of the message names below. |
| `seq` | See below. |
| `data` | Object. Unknown keys make the message `malformed`. |

**`seq`.** On host messages, `seq` is the room's broadcast counter. It increments on `LobbyState`, `GameStarted`, `Events`, `PlayerConnection` and `GameOver`. `TimerSync`, `Pong` and private messages carry the current value without incrementing. Client `seq` is a per-connection counter used only to correlate errors through `refSeq`. A client that sees a gap in broadcast `seq` sends `Reconnect` on its open socket to get a `Resync`.

## 2. Client to host

| Type | Data | Notes |
|---|---|---|
| `Hello` | `name`, `avatar`, `appVersion`, `game` | First message on a new seat. Must arrive within 5 s of connecting. |
| `Reconnect` | `roomCode`, `playerId`, `reconnectToken`, `lastSeq` | First message on a returning socket. |
| `Ready` | `ready` (bool) | Lobby only. |
| `Intent` | `turnSeq`, `intent` | Game only. |
| `Ping` | none | Every 3 s. |
| `Leave` | none | Removes the seat immediately, with no grace period. |

Intent shapes:

```json
{ "turnSeq": 14, "intent": { "kind": "roll" } }
{ "turnSeq": 15, "intent": { "kind": "move", "tokenId": 2 } }
```

`move` is valid only for Ludo. `Intent` must not contain `playerId`, dice values or positions. Any of those is an unknown key, so the message is `malformed`. The acting player always comes from the socket's bound seat.

## 3. Host to one client (private)

| Type | Data | Notes |
|---|---|---|
| `Welcome` | `playerId`, `color`, `reconnectToken` | The only message that ever carries a token. |
| `Resync` | `state`, `remainingTurnMs`, `seq` | Reply to a valid `Reconnect`. Contains no token. |
| `Error` | `code`, `message`, `refSeq` | |
| `Pong` | none | Sent only on the socket that pinged. |

## 4. Host to all

| Type | Data |
|---|---|
| `LobbyState` | `game`, `roomCode`, `config`, `configSummary`, `animationSpeed`, `replaceLeaversWithAi`, `seats` |
| `GameStarted` | `state`, `animationSpeed` |
| `Events` | `events`, `state`, `seq` |
| `TimerSync` | `turnSeq`, `remainingMs`, `running` |
| `PlayerConnection` | `playerId`, `connection`, `graceRemainingMs` |
| `GameOver` | `state`, `ranking`, `stats` |

A seat in `LobbyState` is `{ seatIndex, playerId?, name?, avatar?, color, kind, aiLevel?, ready, connection }`.

`TimerSync` carries remaining milliseconds rather than a timestamp, because device clocks are not synchronised. It is sent when the timer arms, rebinds or resets, and every 5 s while running.

All `state` values come only from `GameModule.stateToPublicJson`. Reconnect tokens exist only in `SessionManager` and the private `Welcome`.

## 5. Error codes

| Code | Meaning | Socket after |
|---|---|---|
| `malformed` | Bad JSON, wrong shape, unknown key, or oversized frame | Open (closed if before `Hello`) |
| `version_mismatch` | `v` differs, or `appVersion` differs in major or minor | Closed |
| `wrong_game` | Game differs from the room's | Closed |
| `room_full` | No free seat, or the game has started | Closed |
| `not_your_turn` | Sender's seat is not current | Open |
| `illegal_move` | Engine rejected the intent | Open |
| `stale_turn` | `turnSeq` is not current | Open |
| `unknown_player` | Unbound socket sent a seat message, or `playerId` or `roomCode` is unknown | Closed |
| `bad_token` | Token hash does not match | Closed |
| `grace_expired` | Seat was already removed | Closed |
| `game_over` | Intent arrived after the game ended | Open |

Messages must be friendly at the UI level. The `message` field is for logs, and never echoes client input or secrets.

## 6. Validation order

The host checks each incoming frame in this order and stops at the first failure. Every rejection leaves game state unchanged.

1. Frame is text and at most 64 KB.
2. Rate limit: a token bucket of 20 messages per second per socket. Excess messages are dropped silently. A socket that exceeds three times the limit for 5 s is closed with code 1008.
3. JSON parses into a valid envelope.
4. `v`, then `game`.
5. `data` matches the type's schema strictly.
6. Socket state allows this type (`Hello` or `Reconnect` first, one binding per socket).
7. For `Intent`: socket is bound to a seat, game is not over, sender is current, `turnSeq` matches.
8. `GameModule.apply`.

The decoder returns null or an `Error` and never throws.

## 7. Connection lifecycle

1. The client connects and sends `Hello`.
2. The host assigns a seat, generates a 128-bit `Random.secure()` token encoded as base64url, stores only its SHA-256 hash, and sends `Welcome`.
3. The host broadcasts `LobbyState`.
4. The host starts the game and broadcasts `GameStarted`. Host settings cannot be changed by clients.
5. Either peer counts the other as gone after 9 s of silence or on socket close.

**Reconnection.** The client retries at 0.5 s, 1 s, 2 s, then every 3 s, and also immediately when the app resumes. The host looks up the seat, compares hashes in constant time, rebinds the seat, closes any previous socket, broadcasts `PlayerConnection`, then sends `Resync`.

**Grace expiry.** After 45 s the host removes the seat through `GameModule.removePlayer`, or converts it to AI if `replaceLeaversWithAi` is on. It broadcasts the resulting `Events` and `PlayerConnection` with `connection: "removed"`. Later attempts get `grace_expired`.

**Host loss.** Clients show "Host lost, waiting…" for 45 s while retrying, then return to the Hub.

## 8. Discovery

| Method | Detail | Platforms |
|---|---|---|
| Bonjour | `_diceparty._tcp`, TXT: `gameType`, `roomCode`, `seatsFree`, `appVersion` | Android, iOS |
| UDP beacon | Port 47820, broadcast every 2 s, JSON `{ "gameType", "roomCode", "seatsFree", "appVersion", "port" }`, requires an Android multicast lock | Android only |
| QR | `diceparty://<ip>:<port>/<ROOM>?g=<gameType>` | Android, iOS |
| Manual | Any format below | Android, iOS |

Accepted addresses:

| Format | Example |
|---|---|
| IPv4 | `192.168.1.5` |
| IPv4 and port | `192.168.1.5:47821` |
| WebSocket URL | `ws://192.168.1.5:47821` |
| Deep link | `diceparty://192.168.1.5:47821/ABCD?g=ludo` |
| Hostname and port | `pixel-7.local:47821` |

The parser returns a result type and never throws. It rejects bad octets, ports 0 and 65536 or above, empty input, a bare `ws://`, embedded spaces and junk. Room codes are 4 characters from an alphabet without look-alikes (no `0`, `O`, `1`, `I`).

If port 47821 is busy, the host tries the next 9 ports and advertises the one it bound.

## 9. Example exchange

```json
{ "v":1, "game":"ludo", "type":"Hello", "seq":1,
  "data":{ "name":"Asha", "avatar":3, "appVersion":"1.0.0", "game":"ludo" } }

{ "v":1, "game":"ludo", "type":"Welcome", "seq":0,
  "data":{ "playerId":"p2", "color":"yellow", "reconnectToken":"<private>" } }

{ "v":1, "game":"ludo", "type":"Intent", "seq":7,
  "data":{ "turnSeq":14, "intent":{ "kind":"roll" } } }

{ "v":1, "game":"ludo", "type":"Events", "seq":31,
  "data":{ "events":[ { "kind":"diceRolled", "playerId":"p2", "value":6 } ], "state":{}, "seq":31 } }

{ "v":1, "game":"ludo", "type":"Error", "seq":31,
  "data":{ "code":"stale_turn", "message":"Turn already moved on", "refSeq":8 } }
```
