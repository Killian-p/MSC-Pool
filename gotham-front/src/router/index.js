import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'
import chartmanager from '../components/ChartManager.vue'
import workingtime from '../components/WorkingTime.vue'
import workingtimes from '../components/WorkingTimes.vue'
import clockmanager from '../components/ClockManager.vue'

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
      component: workingtimes
    },
    {
      path: '/workingTime',
      name: 'workingTime',
      component: workingtime
    },
    {
      path: '/clock',
      name: 'clock',
      component: clockmanager
    },
    {
      path: '/chartManager',
      name: 'chartManager',
      component: chartmanager
    }
  ]
})

export default router
