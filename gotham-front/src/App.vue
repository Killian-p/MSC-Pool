<script setup>
import { RouterLink, RouterView } from 'vue-router'
import TeamsManager from './components/TeamsManager.vue';
import UsersManager from './components/UsersManager.vue';
import WorkingTimes from './components/WorkingTimes.vue';
import WorkingTime from './components/WorkingTime.vue';
import ClockManager from './components/ClockManager.vue';
import ChartManager from './components/ChartManager.vue';
import Login from './components/Login.vue';
</script>

<template>
  <div class="main">
    <div class="nav" v-if="idCurrentUser != null">
      <div>
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
          <button class="form-control nav-buttons" @click="selectComponent('chartManager')"
          :style="currentComponent == 'chartManager' ? 'background-color: #00ABB3;color: #3C4048' : 'background-color: #3C4048;color: #00ABB3'"
          >
            chartManager</button>
        </div>
        <div class="box">
          <button class="form-control nav-buttons" @click="logout"
          style="background-color: #3C4048;color: #00ABB3;position: fixed;margin-top: 300px;"
          >
            Se déconnecter</button>
        </div>
      </div>
      <div v-if="this.currentUserRole === 'ADMIN'">
        <div class="box">
          <button class="form-control nav-buttons" @click="selectComponent('teamsManager')"
          :style="currentComponent == 'teamsManager' ? 'background-color: #00ABB3;color: #3C4048' : 'background-color: #3C4048;color: #00ABB3'"
          >
            Teams Manager
          </button>
        </div>
        <div class="box">
          <button class="form-control nav-buttons" @click="selectComponent('usersManager')"
          :style="currentComponent == 'usersManager' ? 'background-color: #00ABB3;color: #3C4048' : 'background-color: #3C4048;color: #00ABB3'"
          >
            User Management
          </button>
        </div>
        <ClockManager :id-user="idCurrentUser" :username="username">

</ClockManager>
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
</ChartManager >

<TeamsManager v-if="currentComponent == 'teamsManager'" :id-user="idCurrentUser">
</TeamsManager>

<UsersManager v-if="currentComponent == 'usersManager'" :id-user="idCurrentUser">
</UsersManager>

<Login v-if="currentComponent == 'Login' && idCurrentUser == null" @logged="loggin" @username="setUsername" :id-user="idCurrentUser">

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
        currentUserRole: null,
        currentComponent: 'Login',
        username: null,
    }
  },
  methods:{
    loggin(data){
      console.log(data[0], [1])
      this.idCurrentUser = data[0];
      this.currentUserRole = data[1];
    },
    setUsername(name){
      this.username = name;
    },
    selectComponent(comp){
      this.currentComponent = comp;
    },
    logout(){
      axios.post(`${import.meta.env.VITE_BACKEND_URL}/api/users/sign_out`, {user_id: this.idCurrentUser}, { headers:{
        token: localStorage.getItem("token")
      }})
      .then(_ => {
        localStorage.removeItem("token");
        this.selectComponent = "Login";
        this.$emit("logged", null);
        this.connected = false;
        this.currentComponent = 'Login'
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
  width: 8vw;
  height: 8vh;
}

.nav-buttons:hover{
  background-color: #00ABB3;
  color: #3C4048
}

.nav{
  display: flex;
  flex-direction: column;
  background-color: #D9D9D9;
  width: 10vw;
  align-items: center;
}
</style>
