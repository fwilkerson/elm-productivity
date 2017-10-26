const { resolve } = require("path");

module.exports = {
  entry: resolve(__dirname, "src", "index.js"),

  output: {
    filename: "js/bundle.js",
    path: resolve(__dirname, "public"),
    publicPath: "/"
  },

  context: resolve(__dirname, "src"),

  devtool: "inline-source-maps",

  devServer: {
    contentBase: resolve(__dirname, "public"),
    publicPath: "/"
  },

  module: {
    rules: [
      {
        exclude: [/elm-stuff/, /node_modules/],
        test: /\.elm$/,
        use: { loader: "elm-webpack-loader", options: { debug: true } }
      }
    ]
  }
};
