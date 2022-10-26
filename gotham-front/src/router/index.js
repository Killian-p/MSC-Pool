import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: HomeView
    },
    {
      path: '/workingTimes',
      name: 'workingTimes',
    },
    {
      path: '/workingTime',
      name: 'workingTime',
    },
    {
      path: '/clock',
      name: 'clock',
    },
    {
      path: '/chartManager',
      name: 'chartManager',
    }
  ]
})

export default router
