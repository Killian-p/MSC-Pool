<script setup>
import { RouterLink, RouterView } from 'vue-router'
import User from './components/User.vue';
import WorkingTimes from './components/WorkingTimes.vue';
import WorkingTime from './components/WorkingTime.vue';
import ClockManager from './components/ClockManager.vue';
import ChartManager from './components/ChartManager.vue';
import Login from './components/Login.vue';
</script>

<template>
  <div class="main">
    <div class="nav">
      <div v-if="idCurrentUser == null">
        <div class="box">
      <button class="form-control nav-buttons" @click="selectComponent('Login')" 
      :style="currentComponent == 'Login' ? 'background-color: #00ABB3;color: #3C4048' : 'background-color: #3C4048;color: #00ABB3'"
      >  
        Se connecter</button>
        </div>
      </div>
      <div v-if="idCurrentUser != null">
        <div class="box">
      <button class="form-control nav-buttons" @click="selectComponent('workingTimes')" 
      :style="currentComponent == 'workingTimes' ? 'background-color: #00ABB3;color: #3C4048' : 'background-color: #3C4048;color: #00ABB3'"
      >  
        workingTimes</button>
        </div>
        <div class="box">
          <button class="form-control nav-buttons" @click="selectComponent('workingTime')"
          :style="currentComponent == 'workingTime' ? 'background-color: #00ABB3;color: #3C4048' : 'background-color: #3C4048;color: #00ABB3'"
          >
            workingTime</button>
        </div>
        <div class="box">
          <button class="form-control nav-buttons" @click="selectComponent('clock')"
          :style="currentComponent == 'clock' ? 'background-color: #00ABB3;color: #3C4048' : 'background-color: #3C4048;color: #00ABB3'"
          >
          clock</button>
        </div>
        <div class="box">
          <button class="form-control nav-buttons" @click="selectComponent('chartManager')"
          :style="currentComponent == 'chartManager' ? 'background-color: #00ABB3;color: #3C4048' : 'background-color: #3C4048;color: #00ABB3'"
          >
            chartManager</button>
        </div>
        <div class="box">
          <button class="form-control nav-buttons" @click="logout"
          style="background-color: #3C4048;color: #00ABB3"
          >
            Se déconncter</button>
        </div>
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

<Login v-if="currentComponent == 'Login' && idCurrentUser == null" @logged="loggin" :id-user="idCurrentUser">

</Login>
  </div>
  
  </div>

  <!-- <User @logged="loggin" :id-user="idCurrentUser"/> -->


</template>

<script>
import axios from 'axios'
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
    },
    logout(){
      axios.post("${import.meta.env.VITE_BACKEND_URL}/api/users/sign_out", {user_id: this.idCurrentUser}, { headers:{
        token: localStorage.getItem("token")
      }})
      .then(_ => {
        localStorage.removeItem("token");
        this.idCurrentUser = null;
        this.$emit("logged", null);
        this.connected = false;
      })
    }
  }

}
</script>

<style scoped>
.main{
  background-color: #B2B2B2;
  height: 100vh;
  display: flex;
}
.box{
    margin: 20px;
    width: 80%;
}

.nav-buttons{
  border-radius: 45px;
  width: 100%;
  height: 150%;
}

.nav{
  display: flex;
  flex-direction: column;
  background-color: #D9D9D9;
  width: 10vw;
  align-items: center;
}
</style>
