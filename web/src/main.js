import { createApp } from 'vue'
import { ElLoading } from 'element-plus'
import 'element-plus/es/components/loading/style/css'
import 'element-plus/es/components/message/style/css'
import 'element-plus/es/components/message-box/style/css'
import 'element-plus/theme-chalk/dark/css-vars.css'
import './assets/main.css'
import './styles.css'
import App from './App.vue'
import router from './router.js'

document.documentElement.classList.add('dark')

const app = createApp(App)
app.directive('loading', ElLoading.directive)
app.use(router)
app.mount('#app')
