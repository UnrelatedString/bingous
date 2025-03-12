import dev from 'rollup-plugin-dev'
import html from '@rollup/plugin-html'

export default {
	input: 'src/index.js',
	output: {
		dir: 'dist',
		format: 'cjs'
	},
    plugins: [
        html(),
        dev({
            dirs: ["dist"],
        }),
    ],
};
