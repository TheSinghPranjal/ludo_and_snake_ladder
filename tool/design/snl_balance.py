import numpy as np, functools
def jumps_map(jumps,n):
    m={}
    for j in jumps:
        if j['type']=='ladder' or j['rank']<=n: m[j['from']]=j['to']
    return m
def turn_matrix(J):
    T=np.zeros((101,101))
    for s in range(101):
        if s==100: T[100,100]=1; continue
        @functools.lru_cache(None)
        def f(pos,k):
            out={}
            for r in range(1,7):
                if r==6 and k==2: out[s]=out.get(s,0)+1/6; continue
                np_=pos+r
                np_=pos if np_>100 else J.get(np_,np_)
                if np_==100 or r!=6: out[np_]=out.get(np_,0)+1/6
                else:
                    for q,p in f(np_,k+1).items(): out[q]=out.get(q,0)+p/6
            return out
        for q,p in f(s,0).items(): T[s,q]+=p
    return T
def stats(jumps,n,tmax=3000):
    T=turn_matrix(jumps_map(jumps,n)); v=np.zeros(101); v[0]=1; G=[0.0]
    for t in range(tmax): v=v@T; G.append(v[100])
    G=np.array(G); p=np.diff(G); t=np.arange(1,tmax+1)
    pr=p*(1-G[:-1])+p*(1-G[1:])   # first-winner rounds, 2 players
    mean=float((t*pr).sum()); cdf=np.cumsum(pr); med=int(t[np.searchsorted(cdf,0.5)])
    solo=float((t*p).sum()); return mean,med,solo
