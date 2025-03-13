import type { RollupOptions } from 'rollup';
import dev from 'rollup-plugin-dev';
import html from '@rollup/plugin-html';
import terser from '@rollup/plugin-terser';

const config = (args: Record<string, any>): RollupOptions => ({
	input: 'src/index.mjs',
	output: {
		dir: 'dist',
		format: 'es'
	},
    plugins: [
        html({
            title: "bingous",
            meta: [
                { charset: 'utf-8' },
                { property: 'og:type', content: 'website' },
                { property: 'og:title', content: 'bingous' },
                { property: 'og:description', content: 'custom bingo cards, mostly for social media and stuff but like you can totally play bingo with them too if you want' },
                { property: 'og:url', content: 'https://www.bingous.org' },
            ],
        }),
        dev({
            dirs: ["dist"],
            force: args.configServe,
        }),
        terser(),
    ],
});
export default config;
