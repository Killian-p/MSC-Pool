<template>
  <div class="container">
    <div class="cardContainer">
      <div class="whiteCard">
        <div class="contentContainer">
          <p class="title">Create team:</p>
          <div class="labelInput">
            <label> Team's name: </label>
            <input type="text" placeholder="Enter your Team's name." v-model="teamName" />
          </div>
          <div v-if="userRole === 'ADMIN'" class="contentContainer">
            <div>
              <p class="centerText">Select team's manager:</p>
              <div class="dataLine">
                <p class="data little bold">UserName</p>
                <p class="data little bold">Email</p>
              </div>
            </div>
            <div class="lineContainer littleVertScroll">
              <div class="dataLine" v-for="manager in managers" :style="this.selectedManagerId == manager.id ? 'background-color: #d9d9d9' : ''" @click="(this.selectedManagerId = manager.id), setUsersThatAreNotInSelectedTeam()">
                <p class="data little">{{ manager.username }}</p>
                <p class="data little">{{ manager.email }}</p>
              </div>
            </div>
            <div class="createButtonContainer">
              <button class="createButton" @click="createATeam(), setUsersThatAreNotInSelectedTeam()">Create team</button>
            </div>
          </div>
        </div>
      </div>

      <div class="whiteCard">
        <div class="contentContainer">
          <p class="title">Teams list</p>
          <div class="dataLine">
            <p class="data little">Team ID</p>
            <p class="data little">Manager</p>
            <p class="data little">Team's Name</p>
            <p class="data little">Actions</p>
          </div>
          <div class="lineContainer vertScroll">
            <div v-for="team in this.teams" class="dataLine" :style="this.selectedTeamId == team.id ? 'background-color: #d9d9d9' : ''" @click="(this.selectedTeamId = team.id), (this.teamsUsers = team.users), getDataTeam(team), createChart(), setUsersThatAreNotInSelectedTeam()">
              <p class="data little">{{ team.id }}</p>
              <p class="data little">{{ team.managerName }}</p>
              <p class="data little">{{ team.name }}</p>
              <button class="data little button" @click="deleteTeam(team)">
                <img src="../assets/icons8-trash-can.svg" />
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="cardContainer">
      <div class="whiteCard">
        <div class="contentContainer">
          <p class="title">Users</p>
          <div class="dataLine">
            <p class="data little">Username</p>
            <p class="data little">Email</p>
            <p class="data little">Actions</p>
          </div>
          <div class="lineContainer vertScroll">
            <div v-for="user in this.usersNotInTeam" class="dataLine">
              <p class="data little">{{ user.username }}</p>
              <p class="data little">{{ user.email }}</p>
              <button class="data little button" @click="this.addUserToSelectedTeam(user), setUsersThatAreNotInSelectedTeam()">
                <img src="../assets/icons8-add-15.png" />
              </button>
            </div>
          </div>
        </div>
      </div>

      <div class="whiteCard">
        <div class="contentContainer">
          <p class="title">Team's users list</p>
          <div class="dataLine">
            <p class="data little">UserName</p>
            <p class="data little">Email</p>
            <p class="data little">Actions</p>
          </div>
          <div class="lineContainer vertScroll">
            <div v-for="user in teamsUsers" class="dataLine">
              <p class="data little">{{ user.username }}</p>
              <p class="data little">{{ user.email }}</p>
              <div class="data little">
                <button class="button" @click="this.removeUserFromSelectedTeam(user, setUsersThatAreNotInSelectedTeam())">
                  <img src="../assets/icons8-trash-can.svg" />
                </button>
                <button class="button" @click="this.getDataUser(user), createChart()">
                  <img src="../assets/icons8-combo-chart-15.png" />
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="whiteCard">
      <div class="chartDisplay">
        <canvas id="bar-chart" width="879" height="150"></canvas>
      </div>
    </div>
  </div>
</template>
<script>
import axios from "axios";
import Chart from "chart.js/auto";
export default {
  props: {
    idUser: {
      type: Number,
    },
    userRole: {
      type: String,
    },
  },
  data() {
    return {
      managersNames: null,
      users: null,
      managers: null,
      selectedManagerId: null,
      teamName: null,
      teams: null,
      teamsUsers: [],
      selectedTeamId: null,
      usersNotInTeam: [],
      usersOfTeam: [],

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
    };
  },
  mounted() {},
  created() {
    this.getUsers();
    this.getAllTeams();
  },
  computed: {},
  methods: {
    getUsers() {
      axios
        .get(`${import.meta.env.VITE_BACKEND_URL}/api/users`, {
          headers: {
            token: localStorage.getItem("token"),
          },
        })
        .then((res) => {
          this.users = res.data.data.sort((a, b) => {
            return a.email > b.email;
          });
          this.employees = res.data.data
            .filter((elem) => elem.roles === "EMPLOYEE")
            .sort((a, b) => {
              return a.email > b.email;
            });
          this.managers = res.data.data
            .filter((elem) => elem.roles === "MANAGER")
            .sort((a, b) => {
              return a.email > b.email;
            });
        })
        .catch(console.error);
    },
    // getUsers() {
    //   axios
    //     .get(`${import.meta.env.VITE_BACKEND_URL}/api/users`, {
    //       headers: {
    //         token: localStorage.getItem("token"),
    //       },
    //     })
    //     .then((res) => {
    //       this.users = res.data.data.sort((a, b) => {
    //         return a.email > b.email;
    //       });
    //       this.employees = res.data.data
    //         .filter((elem) => elem.roles === "EMPLOYEE")
    //         .sort((a, b) => {
    //           return a.email > b.email;
    //         });
    //       this.managers = res.data.data
    //         .filter((elem) => elem.roles === "MANAGER")
    //         .sort((a, b) => {
    //           return a.email > b.email;
    //         });
    //     })
    //     .catch(console.error);
    // },
    getAllTeams() {
      axios
        .get(`${import.meta.env.VITE_BACKEND_URL}/api/teams`, {
          headers: {
            token: localStorage.getItem("token"),
          },
        })
        .then((res) => {
          this.teams = res.data.data.sort((a, b) => {
            return a.name > b.name;
          });
          let manager = null;
          this.teams.forEach((team) => {
            manager = this.users.filter((user) => user.id === team.manager_id);
            team.managerName = manager[0].username;
            // console.log(this.managerName);
            // console.log(manager);
            // console.log(this.users.filter(user => user.id === team.manager_id));
            // console.log(this.users.filter(user => user.id === team.manager_id));

            // console.log(team.managerName)
          });
        });
    },
    // getAllTeams() {
    //   axios
    //     .get(`${import.meta.env.VITE_BACKEND_URL}/api/teams`, {
    //       headers: {
    //         token: localStorage.getItem("token"),
    //       },
    //     })
    //     .then((res) => {
    //       this.teams = res.data.data.sort((a, b) => {
    //         return a.name > b.name;
    //       });
    //     });
    // },
    createATeam() {
      axios
        .post(
          `${import.meta.env.VITE_BACKEND_URL}/api/teams`,
          {
            team: {
              name: this.teamName,
              manager_id: this?.selectedManagerId ?? this.idUser,
            },
          },
          {
            headers: {
              token: localStorage.getItem("token"),
            },
          }
        )
        .then((res) => {
          let manager = null;
          this.teamsUsers = [];
          manager = this.users.filter((user) => user.id === res.data.data.manager_id);
          res.data.data.managerName = manager[0].username;
          this.teams.push(res.data.data);
        })
        .catch(console.error);
    },
    // createATeam() {
    //   axios
    //     .post(
    //       `${import.meta.env.VITE_BACKEND_URL}/api/teams`,
    //       {
    //         team: {
    //           name: this.teamName,
    //           manager_id: this?.selectedManagerId ?? this.idUser,
    //         },
    //       },
    //       {
    //         headers: {
    //           token: localStorage.getItem("token"),
    //         },
    //       }
    //     )
    //     .then((res) => {
    //       this.teams.push(res.data.data);
    //     })
    //     .catch(console.error);
    // },
    addUserToSelectedTeam(user) {
      axios
        .put(
          `${import.meta.env.VITE_BACKEND_URL}/api/teams/${this.selectedTeamId}/users/${user.id}`,
          {},
          {
            headers: {
              token: localStorage.getItem("token"),
            },
          }
        )
        .then((res) => {
          this.teamsUsers.push(user);
          this.setUsersThatAreNotInSelectedTeam();
          // this.usersNotInTeam.filter((user) => user.id !== user.id)
        })
        .catch(console.error);
    },
    // addUserToSelectedTeam(user) {
    //   axios
    //     .put(
    //       `${import.meta.env.VITE_BACKEND_URL}/api/teams/${this.selectedTeamId}/users/${user.id}`,
    //       {},
    //       {
    //         headers: {
    //           token: localStorage.getItem("token"),
    //         },
    //       }
    //     )
    //     .then((res) => {
    //       this.teamsUsers.push(user);
    //     })
    //     .catch(console.error);
    // },
    removeUserFromSelectedTeam(user) {
      axios
        .delete(`${import.meta.env.VITE_BACKEND_URL}/api/teams/${this.selectedTeamId}/users/${user.id}`, {
          headers: {
            token: localStorage.getItem("token"),
          },
        })
        .then((res) => {
          this.teamsUsers = this.teamsUsers.filter((elem) => elem.id !== user.id);
          this.setUsersThatAreNotInSelectedTeam();
        })
        .catch(console.error);
    },
    setUsersThatAreNotInSelectedTeam() {
      this.usersIds = this.users.map((elem) => elem.id);
      if (this.teamsUsers !== undefined) {
        this.selectedTeamsUsersIds = this.teamsUsers.map((elem) => elem.id);
        this.usersNotInTeam = this.users.filter((user) => !this.selectedTeamsUsersIds.includes(user.id));
      } else {
        this.selectedTeamsUsersIds = [];
        this.usersNotInTeam = this.users;
      }
    },
    // removeUserFromSelectedTeam(user) {
    //   axios
    //     .delete(`${import.meta.env.VITE_BACKEND_URL}/api/teams/${this.selectedTeamId}/users/${user.id}`, {
    //       headers: {
    //         token: localStorage.getItem("token"),
    //       },
    //     })
    //     .then((res) => {
    //       this.teamsUsers = this.teamsUsers.filter((elem) => elem.id !== user.id);
    //     })
    //     .catch(console.error);
    // },
    getDataUser(user) {
      this.nightHours = [];
      this.supHours = [];
      this.workHours = [];
      this.labelDate = [];
      this.dataWork = [];
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
      });
    },
    getDataTeam(team) {
      this.nightHours = [];
      this.supHours = [];
      this.workHours = [];
      this.labelDate = [];
      this.dataWork = [];
      if (team.users !== undefined) {
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
          });
        });
      }
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
    createChart() {
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
    deleteTeam(deletedteam) {
      axios
        .delete(`${import.meta.env.VITE_BACKEND_URL}/api/teams/${deletedteam.id}`, {
          headers: {
            token: localStorage.getItem("token"),
          },
        })
        .then((this.teams = this.teams.filter((team) => team.id !== deletedteam.id)), (this.usersNotInTeam = []));
    },
  },
  watch: {},
};
</script>
<style scoped>
.whiteCard {
  background-color: white;
  border-radius: 16px;
  padding: 20px;
  flex: 1;
  height: 305px;
}
.container {
  display: flex;
  flex-direction: column;
  justify-content: center;
  gap: 20px;
}
.cardContainer {
  display: flex;
  flex-direction: row;
  justify-content: center;
  gap: 20px;
}
.dataLine {
  display: flex;
  flex-direction: row;
  border-radius: 4px;
  align-items: center;
}
.data {
  display: flex;
  justify-content: center;
  margin: 0px;
}
.little {
  flex: 1;
  overflow: hidden;
}
.bold {
  font-weight: bold;
}
.lineContainer {
  display: flex;
  flex-direction: column;
  gap: 10px;
}
.labelInput {
  display: flex;
  align-items: center;
  flex-direction: column;
  gap: 5px;
}
.createContainer {
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}
.containerSelectManager {
  display: flex;
  flex-direction: column;
  gap: 10px;
  /* align-items: center; */
  flex: 1;
}
.title {
  font-weight: bold;
  font-size: 25px;
  margin: 0px;
  text-align: center;
}
.contentContainer {
  display: flex;
  flex-direction: column;
  gap: 20px;
}
.button {
  border: none;
  appearance: none;
  background-color: transparent;
  cursor: pointer;
}
.vertScroll {
  overflow-y: scroll;
  max-height: 220px;
}
.centerText {
  text-align: center;
  margin: 0px;
}
.createButton {
  width: 40%;
}
.createButtonContainer {
  display: flex;
  justify-content: center;
}
.littleVertScroll {
  overflow-y: scroll;
  max-height: 90px;
}
</style>
