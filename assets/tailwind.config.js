module.exports = {
  purge: [
    '../lib/**/*.ex',
    '../lib/**/*.leex',
    '../lib/**/*.eex',
    './js/**/*.js'
  ],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {
      backgroundImage: theme => ({
        'hero-pattern': "url('/images/BrokenTopWhychusMilkyWay.jpg')"
       })
    },
  },
  variants: {
    extend: {},
  },
  plugins: [],
}
