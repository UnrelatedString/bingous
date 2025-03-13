import type { RollupOptions } from 'rollup';
import dev from 'rollup-plugin-dev';
import html from '@rollup/plugin-html';
import terser from '@rollup/plugin-terser';

const config = (args: Record<string, any>): RollupOptions => ({
	input: 'src/index.js',
	output: {
		dir: 'dist',
		format: 'cjs'
	},
    plugins: [
        html({
            title: "bingous.",
        }),
        dev({
            dirs: ["dist"],
            force: args.configServe,
        }),
        terser(),
    ],
});
export default config;
