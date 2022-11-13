<template>
  <div class="container">
    <div class="whiteCard">
      <div class="dataline">
        <p class="data little bold">Id</p>
        <p class="data little bold">User</p>
        <p class="data medium bold">Starts</p>
        <p class="data medium bold">End</p>
        <p class="data medium bold">Temps écoulé</p>
      </div>
      <div class="dataContainer vertScroll">
        <div class="dataline" v-for="worktime in datas">
          <p class="data little">{{ worktime.id }}</p>
          <p class="data little">{{ worktime.user_id }}</p>
          <p class="data medium">{{ new Date(worktime.start).toLocaleString() }}</p>
          <p class="data medium">{{ new Date(worktime.end).toLocaleString() }}</p>
          <p class="data medium">{{ calcPassedTime(worktime.start, worktime.end) }}</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";
import moment from "moment";
export default {
  props: {
    idUser: {
      type: Number,
    },
  },
  data() {
    return {
      datas: null,
    };
  },
  mounted() {
    axios
      .get(`${import.meta.env.VITE_BACKEND_URL}/api/workingtimes/${this.idUser}`, {
        headers: {
          token: localStorage.getItem("token"),
        },
        params: {
          start: new Date("1900-07-08T06:00:00Z").toISOString(),
        },
      })
      .then((_) => {
        this.datas = _.data.data;
        let start;
        let end;
        this.datas.forEach((x) => {
          start = x.start.split("T");
          end = x.end.split("T");
          x.start = start[0] + " " + start[1];
          x.end = end[0] + " " + end[1];
        });
      });
  },
  created() {},
  computed: {},
  methods: {
    calcPassedTime(start, end) {
      let mom = moment.utc(new Date(end) - new Date(start))
      return mom.format("HH:mm:ss");
    },
  },
  watch: {},
};
</script>
<style scoped>
.dataline {
  display: flex;
  flex-direction: columns;
}
.whiteCard {
  display: flex;
  flex-direction: column;
  gap: 10px;
}
.little {
  flex: 1;
}
.medium {
  flex: 2;
}
.data {
  display: flex;
  justify-content: center;
  margin: 0;
}
.dataContainer {
  display: flex;
  flex-direction: column;
  gap: 10px;
}
.container {
  border-radius: 20px;
  display: flex;
  flex-direction: column;
  background-color: white;
  padding: 20px;
  width: 800px;
}
.vertScroll {
  overflow-y: scroll;
  max-height: 600px;
}
.bold {
  font-weight: bold;
}
</style>
