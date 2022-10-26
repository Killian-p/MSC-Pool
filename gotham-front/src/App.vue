<script setup>
import { RouterLink, RouterView } from 'vue-router'
import User from './components/User.vue';
</script>

<template>
  <div>
    <User/>
  </div>
  <div class="main">
    <RouterView/>
  </div>


</template>

<style scoped>
.main{
  background-color: gray;
  height: 90vh;
}
</style>
