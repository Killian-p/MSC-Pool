<template>
  <div class="container">
    <div class="whiteCard">
      <div class="dataline">
        <p class="data">Id</p>
        <p class="data">Starts</p>
        <p class="data">End</p>
      </div>
      <div class="dataline" v-for="worktime in datas">
        <p class="data">{{ worktime.id }}</p>
        <p class="data">{{ worktime.start }}</p>
        <p class="data">{{ worktime.end }}</p>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";
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
  methods: {},
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
  gap: 5px;
}
.data {
  display: flex;
  flex: 1;
  justify-content: center;
}
.container {
 border-radius: 20px;
 display: flex;
 flex-direction: column;
 background-color: white;
 width: 700px;
 height: 600px;
}
</style>
