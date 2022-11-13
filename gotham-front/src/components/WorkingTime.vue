<template>
  <div class="container">
    <div class="formContainer">
      <div class="whiteCard">
        <form v-on:submit.prevent="createWorkingTime" method="post" class="formDate">
          <div class="labelInput">
            <label> starting date : </label>
            <input type="datetime-local" id="startingDate" v-model="startingDateCreate" required />
          </div>
          <div class="labelInput">
            <label> ending date : </label>
            <input type="datetime-local" id="endingDate" v-model="endingDateCreate" required />
          </div>
          <button type="submit">Create</button>
        </form>
      </div>
      <div class="whiteCard">
        <form v-on:submit.prevent="getWorkingTimesForAPerdiod" method="post" class="formDate">
          <div class="labelInput">
            <label> starting date : </label>
            <input type="datetime-local" id="startingDate" v-model="startingDateSearch" required />
          </div>
          <div class="labelInput">
            <label> ending date : </label>
            <input type="datetime-local" id="endingDate" v-model="endingDateSearch" required />
          </div>
          <button type="submit">Search</button>
        </form>
      </div>
    </div>

    <div class="whiteCard" v-if="this.datas.length">
      <div class="dataline">
        <p class="data medium bold">Starts</p>
        <p class="data medium bold">End</p>
        <p class="data little bold">Temps écoulé</p>
        <p class="data little bold">Actions</p>
      </div>
      <div class="dataContainer vertScroll">
        <div class="dataline" v-for="worktime in this.datas" :key="worktime.id">
          <p v-if="this.idSelectedWorkingTime !== worktime.id" class="data medium">{{ new Date(worktime.start).toLocaleString() }}</p>
          <p v-if="this.idSelectedWorkingTime !== worktime.id" class="data medium">{{ new Date(worktime.end).toLocaleString() }}</p>
          <input v-if="this.idSelectedWorkingTime === worktime.id" class="data medium" style="width: 220px" type="datetime-local" id="updateStartingDate" step="1" v-model="worktime.start" :readonly="!(this.idSelectedWorkingTime === worktime.id)" required />
          <input v-if="this.idSelectedWorkingTime === worktime.id" class="data medium" type="datetime-local" id="updateEndingDate" step="1" v-model="worktime.end" :readonly="!(this.idSelectedWorkingTime === worktime.id)" required />

          <p class="data little">{{ new Date(new Date(worktime.end) - new Date(worktime.start)).toLocaleTimeString() }}</p>
          <div class="data little">
            <button v-if="!(this.idSelectedWorkingTime === worktime.id)" class="button" @click="deleteAWorkingTime(worktime.id)">
              <img src="../assets/icons8-trash-can.svg" />
            </button>
            <button class="button" v-if="!(this.idSelectedWorkingTime === worktime.id)" @click="this.idSelectedWorkingTime = worktime.id">
              <img src="../assets/icons8-edit.svg" />
            </button>
            <button class="button" v-if="this.idSelectedWorkingTime === worktime.id" @click="updateAWorkingTime(worktime.id, worktime.start, worktime.end), (this.idSelectedWorkingTime = null)">
              <img src="../assets/icons8-done.svg" />
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";
export default {
  components: {},
  props: {
    idUser: {
      type: Number,
    },
  },
  data() {
    return {
      startingDateCreate: null,
      endingDateCreate: null,
      startingDateSearch: null,
      endingDateSearch: null,
      datas: [],
      updateMode: false,
      idSelectedWorkingTime: null,
    };
  },
  mounted() {},
  created() {},
  computed: {},
  methods: {
    updateAWorkingTime(idWorkingTime, start, end) {
      axios
        .put(
          `${import.meta.env.VITE_BACKEND_URL}/api/workingtimes/${idWorkingTime}`,
          {
            workingtime: {
              start: new Date(start).toISOString(),
              end: new Date(end).toISOString(),
            },
          },
          {
            headers: {
              token: localStorage.getItem("token"),
            },
          }
        )
        .catch(console.error);
    },
    deleteAWorkingTime(idWorkingTime) {
      axios
        .delete(`${import.meta.env.VITE_BACKEND_URL}/api/workingtimes/${idWorkingTime}`, {
          headers: {
            token: localStorage.getItem("token"),
          },
        })
        .catch(console.error)
        .then(() => {
          this.datas = this.datas.filter((elem) => elem.id !== idWorkingTime);
        });
    },
    getWorkingTimesForAPerdiod() {
      axios
        .get(`${import.meta.env.VITE_BACKEND_URL}/api/workingtimes/${this.idUser}`, {
          headers: {
            token: localStorage.getItem("token"),
          },
          params: {
            start: new Date(this.startingDateSearch).toISOString(),
            end: new Date(this.endingDateSearch).toISOString(),
          },
        })
        .then((res) => {
          this.datas = res.data.data;
          let start;
          let end;
          this.datas.forEach((x) => {
            start = x.start.split("T");
            end = x.end.split("T");
            x.start = start[0].split(".")[0] + " " + start[1].split(".")[0];
            x.end = end[0].split(".")[0] + " " + end[1].split(".")[0];
          });
        })
        .catch(console.error);
    },
    createWorkingTime() {
      axios
        .post(
          `${import.meta.env.VITE_BACKEND_URL}/api/workingtimes/${this.idUser}`,
          {
            workingtime: {
              start: new Date(this.startingDateCreate).toISOString(),
              end: new Date(this.endingDateCreate).toISOString(),
            },
          },
          {
            headers: {
              token: localStorage.getItem("token"),
            },
          }
        )
        .then((res) => {
          let start = res.data.data.start.split("T");
          let end = res.data.data.end.split("T");
          res.data.data.start = start[0] + " " + start[1];
          res.data.data.end = end[0] + " " + end[1];
          this.datas.push(res.data.data);
        });
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
}
.whiteCard {
  display: flex;
  flex-direction: column;
  gap: 10px;
}
.formContainer {
  display: flex;
  flex-direction: row;
  gap: 20px;
  justify-content: center;
}
.container {
  width: 800px;
  display: flex;
  justify-content: center;
  flex-direction: column;
  gap: 20px;
}
.formDate {
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  gap: 10px;
}
.labelInput {
  display: flex;
  flex-direction: column;
  gap: 5px;
}
.dataline {
  display: flex;
  flex-direction: columns;
  gap: 10px;
}
.data {
  display: flex;
  justify-content: center;
  margin: 0;
}
.little {
  flex: 1;
}
.medium {
  flex: 2;
}
.dataContainer {
  display: flex;
  flex-direction: column;
  gap: 10px;
}
.vertScroll {
  overflow-y: scroll;
  max-height: 500px;
}
.bold {
  font-weight: bold;
}
.button {
  border: none;
  appearance: none;
  background-color: white;
}
</style>
