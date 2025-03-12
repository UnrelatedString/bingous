import path from "path";
import webpack from 'webpack';
import _ from 'webpack-dev-server'; // thanks https://github.com/DefinitelyTyped/DefinitelyTyped/issues/27570#issuecomment-437115227
import CopyPlugin from "copy-webpack-plugin";

const dist = path.resolve(__dirname, "dist");

// thank you https://stackoverflow.com/a/71302165

const config = (
  _env: Record<string, any>,
  _argv: Record<string, any>,
): webpack.Configuration => ({
  mode: "production",
  entry: {
    index: "./src/index.js"
  },
  output: {
    path: dist,
    filename: "[name].js",
    clean: true
  },
  devServer: {
    static: path.resolve(__dirname, 'dist'),
    client: {
      overlay: false,
    },
  },
  plugins: [
    new CopyPlugin({
      patterns: [
        path.resolve(__dirname, "static"),
      ]
    }),
  ],
});

export default config;
