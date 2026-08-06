import { ref } from 'vue'

const MOBILE_QUERY = '(max-width: 767px)'
const isMobile = ref(false)

if (typeof window !== 'undefined') {
  const mql = window.matchMedia(MOBILE_QUERY)
  isMobile.value = mql.matches
  mql.addEventListener('change', (e) => { isMobile.value = e.matches })
}

export function useViewport() {
  return { isMobile }
}
