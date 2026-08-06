/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{vue,js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        dark: {
          950: '#0a0a0c',
          900: '#121215',
          800: '#1a1a1f',
          700: '#232329',
          600: '#2d2d34',
          500: '#383840',
          400: '#464650',
          300: '#565660',
          200: '#6e6e7a',
          100: '#8b8b9a',
          50: '#b4b4c4',
        }
      },
      fontFamily: {
        sans: ['Inter', 'system-ui', 'sans-serif'],
      }
    },
  },
  plugins: [],
}
