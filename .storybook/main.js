const path = require("path");

module.exports = {
  stories: ["../src/**/*.stories.(tsx|mdx)"],
  // Add any Storybook addons you want here: https://storybook.js.org/addons/
  addons: [
    "@storybook/addon-actions",
    "@storybook/addon-links",
    "@storybook/addon-knobs",
    "@storybook/preset-scss",
    "@storybook/addon-a11y",
    "@storybook/addon-docs"
  ],
  webpackFinal: async (config) => {
    config.module.rules.push({
      test: /\.scss$/,
      use: ["style-loader", "css-loader", "sass-loader"],
      include: path.resolve(__dirname)
    });
    return config;
  }
};

