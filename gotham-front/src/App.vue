<script setup>
import { RouterLink, RouterView } from 'vue-router'
import User from './components/User.vue';
import WorkingTimes from './components/WorkingTimes.vue';
import WorkingTime from './components/WorkingTime.vue';
import ClockManager from './components/ClockManager.vue';
import ChartManager from './components/ChartManager.vue';
</script>

<template>
  <div class="main">
    
    <div class="nav">
      <div class="box">
      <button class="form-control" @click="selectComponent('workingTimes')">workingTimes</button>
        </div>
        <div class="box">
          <button class="form-control" @click="selectComponent('workingTime')">workingTime</button>
        </div>
        <div class="box">
          <button class="form-control" @click="selectComponent('clock')">clock</button>
        </div>
        <div class="box">
          <button class="form-control" @click="selectComponent('chartManager')">chartManager</button>
        </div>
    </div>
    <div>
    <WorkingTimes v-if="currentComponent == 'workingTimes'" :id-user="idCurrentUser">

    </WorkingTimes>
    <WorkingTime v-if="currentComponent == 'workingTime'" :id-user="idCurrentUser">

    </WorkingTime>
    <ClockManager v-if="currentComponent == 'clock'" :id-user="idCurrentUser">

    </ClockManager>
    <ChartManager v-if="currentComponent == 'chartManager'" :id-user="idCurrentUser">

    </ChartManager>
  </div>
  
  </div>
  <div>
    <User @logged="loggin" :id-user="idCurrentUser"/>
  </div>
  


</template>

<script>
export default {
  components: {
    WorkingTimes
},
  props: [
  ],
  data () {
    return {
        connected: false,
        idCurrentUser: null,
        currentComponent: null,
    }
  },
  methods:{
    loggin(id){
      this.idCurrentUser = id;
    },
    selectComponent(comp){
      this.currentComponent = comp;
    }
  }

}
</script>

<style scoped>
.main{
  background-color: gray;
  height: 90vh;
}
.box{
    margin: 2px;
}

.nav{
  display: flex;
}
</style>
