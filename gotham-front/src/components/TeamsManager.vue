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
  <div>
    <h1>
    TEAMS LIST
    </h1>
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
          <td :style="this.selectedTeamId == team.id ? 'background-color: #00ABB3;color: #3C4048' : 'background-color: #3C4048;color: #00ABB3'" @click="this.selectedTeamId = team.id, this.teamsUsers=team.users, setUsersThatAreNotInSelectedTeam(team)">{{team.id}}</td>
          <td :style="this.selectedTeamId == team.id ? 'background-color: #00ABB3;color: #3C4048' : 'background-color: #3C4048;color: #00ABB3'" @click="this.selectedTeamId = team.id, this.teamsUsers=team.users, setUsersThatAreNotInSelectedTeam(team)">{{team.manager_id}}</td>
          <td :style="this.selectedTeamId == team.id ? 'background-color: #00ABB3;color: #3C4048' : 'background-color: #3C4048;color: #00ABB3'" @click="this.selectedTeamId = team.id, this.teamsUsers=team.users, setUsersThatAreNotInSelectedTeam(team)">{{team.name}}</td>
        </tr>
      </tbody>
    </table>
    <div>
      <h1>
    TEAM'S USERS LIST
    </h1>
      <table>
      <thead>
        <th> UserName </th>
        <th> Email </th>
      </thead>
      <tbody>
        <tr v-for="user in teamsUsers">
          <td>{{user.username}}</td>
          <td>{{user.email}}</td>
          <button @click="this.removeUserFromSelectedTeam(user)">
            REMOVE
          </button>
        </tr>
      </tbody>
    </table>
    </div>
    <div>
      <h1>
    ALL USERS LIST
    </h1>
      <table>
      <thead>
        <th> UserName </th>
        <th> Email </th>
      </thead>
      <tbody>
        <tr v-for="user in this.usersOfTeam">
          <td >{{user.username}}</td>
          <td >{{user.email}}</td>
          <button @click="this.addUserToSelectedTeam(user)"> ADD </button>
        </tr>
      </tbody>
    </table>
    </div>
  </div>
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
        users: [],
        managers: [],
        selectedManagerId: null,
        teamName: null,
        teams: null,
        teamsUsers: [],
        selectedTeamId: null,
        usersOfTeam: [],
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
      axios.get(`${import.meta.env.VITE_BACKEND_URL}/api/users`, { headers: {
        token: localStorage.getItem("token")
      }}).then(res => {
        this.users = res.data.data.sort((a,b) => {return a.email > b.email})
        this.employees = res.data.data.filter((elem) => elem.roles === "EMPLOYEE").sort((a,b) => {return a.email > b.email})
        this.managers = res.data.data.filter((elem) => elem.roles === "MANAGER").sort((a,b) => {return a.email > b.email})
      }).catch(console.error);
    },
    getAllTeams(){
      axios.get(`${import.meta.env.VITE_BACKEND_URL}/api/teams`, { headers: {
        token: localStorage.getItem("token")
      }}).then(res => {
        console.log(res.data.data)
        this.teams = res.data.data.sort((a,b) => {return a.name > b.name})
      }
      )
    },
    createATeam(){
      axios.post(`${import.meta.env.VITE_BACKEND_URL}/api/teams`, { team:{
        name: this.teamName,
        manager_id: this?.selectedManagerId ?? this.idUser}}, {
      headers: {
        token: localStorage.getItem("token")
      }}).then(res => {
        console.log(res)
        this.teams.push(res.data.data)
      }).catch(console.error)
    },
    addUserToSelectedTeam(user){
      axios.put(`${import.meta.env.VITE_BACKEND_URL}/api/teams/${this.selectedTeamId}/users/${user.id}`, {}, {
      headers: {
        token: localStorage.getItem("token")
      }}).then(res => {
          console.log(res)
          this.teamsUsers.push(user)
      }).catch(console.error)
    },
    removeUserFromSelectedTeam(user){
      axios.delete(`${import.meta.env.VITE_BACKEND_URL}/api/teams/${this.selectedTeamId}/users/${user.id}`, {
        headers: {
        token: localStorage.getItem("token")
      }}).then(res => {
          console.log(res)
          this.teamsUsers = this.teamsUsers.filter((elem) => elem.id !== user.id)
        }).catch(console.error)
      },
      setUsersThatAreNotInSelectedTeam(team){
        this.usersIds = this.users.map(elem => elem.id)
        this.selectedTeamsUsersIds = this.teamsUsers.map(elem => elem.id)
        this.usersNotInSelectedTeam = this.usersIds.filter(x => !this.selectedTeamsUsersIds.includes(x))
        console.log("user ids", this.usersIds);
        console.log("selected team's users ids",this.selectedTeamsUsersIds);
        console.log("ids that are not in selected team id list",this.usersNotInSelectedTeam);
        this.UsersNotInTeam = this.users.filter(user => !this.usersIds.find(id => (id === user.id)))
        console.log(this.UsersNotInTeam);
        // this.UsersNotInSelectedTeamsIds = this.usersIds.filter(x => !this.usersIds.includes(x))
        // console.log("Users of Selected Team", team.users)
        // delete team.users.workingtimes;
        // console.log("Users of Selected Team APRES CHANGEMENT", team.users)
        // this.usersOfTeam = this.users.filter(x => !team.users.includes(x))
        // console.log("team", team)
        // console.log("Users of Selected Team", team.users)
        // console.log("Tableau de tout les users", this.users);
        // console.log("Tableau resultat", this.usersOfTeam);
        // console.log(this.usersOfTeam);
    }
  },
    watch: {
    }
  }
  </script>
  <style scoped>
  
  </style>
  