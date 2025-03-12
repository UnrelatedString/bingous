import dev from 'rollup-plugin-dev'
import html from '@rollup/plugin-html'

export default {
	input: 'src/index.js',
	output: {
		dir: 'dist',
		format: 'es'
	},
    plugins: [
        html({
            title: "bingous.",
        }),
        dev({
            dirs: ["dist"],
            force: true,
        }),
    ],
};
