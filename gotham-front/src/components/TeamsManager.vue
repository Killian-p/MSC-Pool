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
          <td :style="this.selectedTeamId == team.id ? 'background-color: #00ABB3;color: #3C4048' : 'background-color: #3C4048;color: #00ABB3'" @click="this.selectedTeamId = team.id, this.teamsUsers=team.users, getDataTeam(team), createChart()">{{team.id}}</td>
          <td :style="this.selectedTeamId == team.id ? 'background-color: #00ABB3;color: #3C4048' : 'background-color: #3C4048;color: #00ABB3'" @click="this.selectedTeamId = team.id, this.teamsUsers=team.users, getDataTeam(team), createChart()">{{team.manager_id}}</td>
          <td :style="this.selectedTeamId == team.id ? 'background-color: #00ABB3;color: #3C4048' : 'background-color: #3C4048;color: #00ABB3'" @click="this.selectedTeamId = team.id, this.teamsUsers=team.users, getDataTeam(team), createChart()">{{team.name}}</td>
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
          <button @click="this.getDataUser(user), createChart()">DisplayChart</button>
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
        <tr v-for="user in this.users">
          <td >{{user.username}}</td>
          <td >{{user.email}}</td>
          <button @click="this.addUserToSelectedTeam(user)"> ADD </button>
        </tr>
      </tbody>
    </table>
    </div>
  </div>
  <div class = "chartDisplay"><canvas id="bar-chart" width="879" height="150"></canvas></div>
  </template>
  <script>
  import axios from 'axios';
  import Chart from "chart.js/auto";
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
        teamsUsers: null,
        selectedTeamId: null,
        arrayStart: [],
        arrayEnd: [],
        nightTimes: [],
        nightTimesBis: [],
        dataWork: [],

        dataWorkUnique: null,
        labelDate: null,
        supHours: null,
        nightHours: null,
        workHours: null,

        workTime: null,
      }
    },
    mounted () {
    },
    created () {
      this.getUsers();
      this.getAllTeams();

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
        this.teams = res.data.data.sort((a,b) => {return a.name > b.name})
      }
      )},

    createATeam(){
      axios.post(`${import.meta.env.VITE_BACKEND_URL}/api/teams`, { team:{
        name: this.teamName,
        manager_id: this?.selectedManagerId ?? this.idUser}}, {
      headers: {
        token: localStorage.getItem("token")
      }}).then(res => {
        this.teams.push(res.data.data)
      }).catch(console.error)
    },
    addUserToSelectedTeam(user){
      axios.put(`${import.meta.env.VITE_BACKEND_URL}/api/teams/${this.selectedTeamId}/users/${user.id}`, {}, {
      headers: {
        token: localStorage.getItem("token")
      }}).then(res => {
          this.teamsUsers.push(user)
      }).catch(console.error)
    },
    removeUserFromSelectedTeam(user){
      axios.delete(`${import.meta.env.VITE_BACKEND_URL}/api/teams/${this.selectedTeamId}/users/${user.id}`, {
        headers: {
        token: localStorage.getItem("token")
      }}).then(res => {
          this.teamsUsers = this.teamsUsers.filter((elem) => elem.id !== user.id)
      }).catch(console.error)
    }, 
    getDataUser(user){
      this.nightHours = [];
      this.supHours = [];
      this.workHours = [];
      this.labelDate = [];
      this.dataWork = [];
      console.log(user)
        user.workingtimes.forEach((_) => {
          this.arrayStart = _.start.split("T");
          this.arrayEnd = _.end.split("T");
          if (this.arrayEnd[0] != this.arrayStart[0]) {
              this.nightTimes = (new Date(this.arrayEnd[0]).getTime() - new Date(_.start).getTime()) / 3600000 - 1;
              this.nightTimesBis = (new Date(_.end).getTime() - new Date(_.start).getTime()) / 3600000 - ((new Date(this.arrayEnd[0]).getTime() - new Date(_.start).getTime()) / 3600000 - 1);
              this.dataWork.push({
                date: this.arrayStart[0],
                workTime: 0,
                supTime: 0,
                nightTime: this.nightTimes,
              });
              this.dataWork.push({
                date: this.arrayEnd[0],
                workTime: 0,
                supTime: 0,
                nightTime: this.nightTimesBis,
              });
            } else {
              this.workTime = (new Date(_.end).getTime() - new Date(_.start).getTime()) / 3600000;
              this.dataWork.push({
                date: this.arrayStart[0],
                workTime: this.workTime,
                supTime: 0,
                nightTime: 0,
              });
            }
            this.date();
        })
      ;
    },
    getDataTeam(team){
      this.nightHours = [];
      this.supHours = [];
      this.workHours = [];
      this.labelDate = [];
      this.dataWork = [];
      team.users.forEach((i) => {
        i.workingtimes.forEach((_) => {
          this.arrayStart = _.start.split("T");
          this.arrayEnd = _.end.split("T");
          if (this.arrayEnd[0] != this.arrayStart[0]) {
              this.nightTimes = (new Date(this.arrayEnd[0]).getTime() - new Date(_.start).getTime()) / 3600000 - 1;
              this.nightTimesBis = (new Date(_.end).getTime() - new Date(_.start).getTime()) / 3600000 - ((new Date(this.arrayEnd[0]).getTime() - new Date(_.start).getTime()) / 3600000 - 1);
              this.dataWork.push({
                date: this.arrayStart[0],
                workTime: 0,
                supTime: 0,
                nightTime: this.nightTimes,
              });
              this.dataWork.push({
                date: this.arrayEnd[0],
                workTime: 0,
                supTime: 0,
                nightTime: this.nightTimesBis,
              });
            } else {
              this.workTime = (new Date(_.end).getTime() - new Date(_.start).getTime()) / 3600000;
              this.dataWork.push({
                date: this.arrayStart[0],
                workTime: this.workTime,
                supTime: 0,
                nightTime: 0,
              });
            }
            this.date();
        })
      });
    },
    date() {
      
      this.dataWork.sort((a, b) => new Date(a.date) - new Date(b.date));
      let i;
      for (i = 0; i < this.dataWork.length - 1; i++) {
        if (this.dataWork[i].date == this.dataWork[i + 1].date) {
          this.dataWork[i].workTime = this.dataWork[i].workTime + this.dataWork[i + 1].workTime;
          this.dataWork[i + 1].workTime = 0;
          this.dataWork[i].supTime = this.dataWork[i].supTime + this.dataWork[i + 1].supTime;
          this.dataWork[i + 1].supTime = 0;
          this.dataWork[i].nightTime = this.dataWork[i].nightTime + this.dataWork[i + 1].nightTime;
          this.dataWork[i + 1].nightTime = 0;
        }
      }
      for (i = 0; i < this.dataWork.length - 1; i++) {
        if (this.dataWork[i].date == this.dataWork[i + 1].date) {
          this.dataWork[i].workTime = this.dataWork[i].workTime + this.dataWork[i + 1].workTime;
          this.dataWork[i + 1].workTime = 0;
          this.dataWork[i].supTime = this.dataWork[i].supTime + this.dataWork[i + 1].supTime;
          this.dataWork[i + 1].supTime = 0;
          this.dataWork[i].nightTime = this.dataWork[i].nightTime + this.dataWork[i + 1].nightTime;
          this.dataWork[i + 1].nightTime = 0;
        }
      }
      this.deleteBlankDate();
      this.getHourSup();
      this.SumFuction();
      this.workTimeGroup();
    },
    deleteBlankDate() {
      
      this.dataWorkUnique = new Array();
      let i;
      for (i = 0; i < this.dataWork.length; i++) {
        if (this.dataWork[i].workTime != 0 || this.dataWork[i].nightTime != 0) {
          this.dataWorkUnique.push(this.dataWork[i]);
        }
      }
    },
    getHourSup() {
      
      let i;
      for (i = 0; i < this.dataWorkUnique.length; i++) {
        if (this.dataWorkUnique[i].workTime > 8) {
          this.dataWorkUnique[i].supTime = this.dataWorkUnique[i].workTime - 8;
          this.dataWorkUnique[i].workTime = 8;
        }
      }
    },
    workTimeGroup() {
      let i;
      this.labelDate = new Array();
      this.workHours = new Array();
      this.nightHours = new Array();
      this.supHours = new Array();
      for (i = 0; i < this.dataWorkUnique.length; i++) {
        this.labelDate.push(this.dataWorkUnique[i].date), this.workHours.push(this.dataWorkUnique[i].workTime), this.nightHours.push(this.dataWorkUnique[i].nightTime), this.supHours.push(this.dataWorkUnique[i].supTime);
      }
    },
    createChart(){
      var chartExist = Chart.getChart("bar-chart");
      if (chartExist != undefined) {
        chartExist.destroy();
      }
      new Chart(document.getElementById("bar-chart"), {
        type: "bar",
        data: {
          labels: this.labelDate,
          color: "#3e95cd",
          datasets: [
            {
              data: this.workHours,
              label: "Normal Hours",
              backgroundColor: "#8BBCCC",
              fill: false,
            },
            {
              data: this.supHours,
              label: "Extra hours",
              backgroundColor: "#4C6793",
              fill: false,
            },
            {
              data: this.nightHours,
              label: "Night shifts",
              backgroundColor: "#5C2E7E",
              fill: false,
            },
          ],
        },
        options: {
          scales: {
            y: {
              ticks: { color: "#000000", beginAtZero: true },
              stacked: true,
            },
            x: {
              ticks: { color: "#000000", beginAtZero: true },
              stacked: true,
            },
          },
          plugins: {
            legend: {
              display: true,
              labels: { color: "#000000" },
            },
          },
        },
      });
    },
  },
    watch: {
    }
  }
  </script>
  <style scoped>
  
  </style>
  