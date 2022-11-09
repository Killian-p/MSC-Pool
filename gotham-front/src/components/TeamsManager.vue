<template>
  <div>
    <h1>
    create a team:
    </h1>
      <label>
        Team's name:
      </label>
    <input type="text" placeholder="Enter your Team's name." v-model="teamName" />
    <div v-if="userRole === 'ADMIN'">
      <label >
        Selecter your manager:
    </label>
    <table>
      <thead>
        <tr>
          <th>
            UserName
          </th>
          <th>
            Email
          </th>
          <th>
            Role
          </th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="manager in managers">
          <td :style="this.selectedManagerId == manager.id ? 'background-color: #00ABB3;color: #3C4048' : 'background-color: #3C4048;color: #00ABB3'" @click="this.selectedManagerId = manager.id">{{manager.username}}</td>
          <td :style="this.selectedManagerId == manager.id ? 'background-color: #00ABB3;color: #3C4048' : 'background-color: #3C4048;color: #00ABB3'" @click="this.selectedManagerId = manager.id">{{manager.email}}</td>
          <td :style="this.selectedManagerId == manager.id ? 'background-color: #00ABB3;color: #3C4048' : 'background-color: #3C4048;color: #00ABB3'" @click="this.selectedManagerId = manager.id">{{manager.roles}}</td>
        </tr>
      </tbody>
    </table>
    <button @click="createATeam">
      CREATE A TEAM
    </button>
  </div>
  
  </div>
  
  <div>
    
  </div>
  <table>
      <thead>
        <tr>
          <th>
            Team ID
          </th>
          <th>
            Manager's Id
          </th>
          <th>
            Team's Name
          </th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="team in teams">
          <td :style="this.selectedTeamId == team.id ? 'background-color: #00ABB3;color: #3C4048' : 'background-color: #3C4048;color: #00ABB3'" @click="this.selectedTeamId = team.id">{{team.id}}</td>
          <td :style="this.selectedTeamId == team.id ? 'background-color: #00ABB3;color: #3C4048' : 'background-color: #3C4048;color: #00ABB3'" @click="this.selectedTeamId = team.id">{{team.manager_id}}</td>
          <td :style="this.selectedTeamId == team.id ? 'background-color: #00ABB3;color: #3C4048' : 'background-color: #3C4048;color: #00ABB3'" @click="this.selectedTeamId = team.id">{{team.name}}</td>
        </tr>
      </tbody>
    </table>
  </template>
  <script>
  import axios from 'axios'
  export default {
    props: {
      idUser: {
        type: Number,
      },
      userRole: {
        type: String,
      }
    },
    data () {
      return {
        users: null,
        managers: null,
        selectedManagerId: null,
        teamName: null,
        teams: null,
        selectedTeamId: null,
      }
    },
    mounted () {
    },
    created () {
      this.getUsers();
      this.getAllTeams();
      console.log(this.userRole)

    },
    computed: {

    },
    methods: {
    getUsers(){
      axios.get(${import.meta.env.VITE_BACKEND_URL}/api/users`, { headers: {
        token: localStorage.getItem("token")
      }}).then(res => {
        this.users = res.data.data.sort((a,b) => {return a.email > b.email})
        this.employees = res.data.data.filter((elem) => elem.roles === "EMPLOYEE").sort((a,b) => {return a.email > b.email})
        this.managers = res.data.data.filter((elem) => elem.roles === "MANAGER").sort((a,b) => {return a.email > b.email})
      }).catch(console.error);
    },

    getAllTeams(){
      axios.get(${import.meta.env.VITE_BACKEND_URL}/api/teams`, { headers: {
        token: localStorage.getItem("token")
      }}).then(res => {
        console.log(res.data.data)
        this.teams = res.data.data.sort((a,b) => {return a.name > b.name})
      }
      )},
    createATeam(){
      axios.post(${import.meta.env.VITE_BACKEND_URL}/api/teams`, { team:{
        name: this.teamName,
        manager_id: this.selectedManagerId}}, {
      headers: {
        token: localStorage.getItem("token")
      }}).then(res => {
        console.log(res)
        this.teams.push(res.data.data)
      }).catch(console.error)
    },
  },
    watch: {
    }
  }
  </script>
  <style scoped>
  
  </style>
  