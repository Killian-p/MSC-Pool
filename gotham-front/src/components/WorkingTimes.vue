<template>
  <body><canvas id="line-chart" width="450" height="100"></canvas></body>
</template>

<script>
import Chart from 'chart.js/auto';
import axios from 'axios'
export default {
  components: {
  },
  props: [
  ],
  data () {
    return {
      startTime: null,
      endTime: null,
      labelStart: null,
      labelEnd: null,
      arrayStart: null,
      arrayEnd: null,
      startDate: null,
      endDate: null,
      workTime: null,
    }
  },
  mounted () {
    new Chart(document.getElementById("line-chart"), {
      type: 'line',
      data: {
        labels: [this.labelStart],
        datasets: [{
          data: [2,3,5],
          label: "User1",
          borderColor: "#3e95cd",
          fill: false
        }],
      },
      options: {
        title: {
          display: true,
          text: 'Working times per user'
        }
      }
    });
  },
  created () {
    this.seeWorkingTimes();
  },
  computed: {
  },
  methods: {
    seeWorkingTimes(){
        axios.get("http://localhost:4000/api/workingtimes/1/1")
        .then((response) => {
          this.endTime = response.data.data.end
          this.startTime = response.data.data.start

          this.arrayStart = this.startTime.split("T")
          this.arrayEnd = this.endTime.split("T")

          this.startDate = parseInt(this.arrayStart[1])
          this.endDate = parseInt(this.arrayEnd[1])

          this.labelStart = this.arrayStart[0]
          this.labelEnd = this.arrayEnd[0]

          this.workTime = this.endDate - this.startDate
          
            console.log(this.startDate);
            console.log(this.endDate);
            console.log(this.labelStart);
            console.log(this.labelEnd);
            console.log(this.workTime);
            
        })
        .catch(console.error);
    },
  },
  watch: {
  }
}
</script>

<style scoped lang="scss">
</style>