module.exports = {
  content: [
    "./app/views/**/*.{html.erb,html}",
    "./app/helpers/**/*.rb",
    "./app/javascript/**/*.js"
  ],
  theme: {
    extend: {},
  },
  plugins: [require("daisyui")],
}
