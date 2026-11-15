// Renders SVG sources to PNG at 1x, 2x and 3x with the bundled fonts.
// Usage: node tool/render_png.mjs jobs.json   (jobs: [{svg, png, w}], png is the 1x path)
import { Resvg } from '@resvg/resvg-js';
import { readFileSync, writeFileSync, mkdirSync } from 'node:fs';
import { dirname, basename, join } from 'node:path';

const fontFiles = ['Fredoka-SemiBold.ttf', 'Fredoka-Bold.ttf', 'Nunito-Regular.ttf', 'Nunito-Bold.ttf']
  .map((f) => join('assets', 'fonts', f));
const jobs = JSON.parse(readFileSync(process.argv[2], 'utf8'));
let n = 0;
for (const job of jobs) {
  const svg = readFileSync(job.svg, 'utf8');
  for (const scale of [1, 2, 3]) {
    const dir = scale === 1 ? dirname(job.png) : join(dirname(job.png), `${scale}.0x`);
    mkdirSync(dir, { recursive: true });
    const r = new Resvg(svg, {
      fitTo: { mode: 'width', value: Math.round(job.w * scale) },
      font: { fontFiles, loadSystemFonts: false, defaultFontFamily: 'Nunito' },
    });
    writeFileSync(join(dir, basename(job.png)), r.render().asPng());
    n += 1;
  }
}
console.log(`rendered ${n} png files`);
