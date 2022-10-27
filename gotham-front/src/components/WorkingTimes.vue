<template>
  <body><canvas id="line-chart" width="450" height="100"></canvas></body>
</template>

<script>
import Chart from 'chart.js/auto';
import axios from 'axios'
export default {
  components: {
  },
  props: {
    idUser: {
      type: Number,
    }
  },
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
  async mounted () {
    await this.seeWorkingTimes();
    console.log(this.labelStart[15]);
    console.log(this.workTime[15]);
    debugger;
    new Chart(document.getElementById("line-chart"), {
      type: 'line',
      data: {
        labels: this.labelStart,
        datasets: [{
          data: this.workTime,
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
    
  },
  computed: {
  },
  methods: {
    async seeWorkingTimes(){
        await axios.get(`http://localhost:4000/api/workingtimes/${this.idUser}`, {params :{
          start: new Date("2010-07-08T06:00:00Z").toISOString(),
        }})
        .then((response) => {
          let arrayOfDates = response.data.data;
          this.labelStart = new Array();
          this.labelEnd = new Array();
          this.workTime = new Array();
          arrayOfDates.forEach(_ => 
          {
          this.arrayStart = _.start.split("T");
          this.arrayEnd = _.end.split("T");

          this.startDate = parseInt(this.arrayStart[1]);
          this.endDate = parseInt(this.arrayEnd[1]);

          this.labelStart.push(this.arrayStart[0].toString());
          this.labelEnd.push(this.arrayEnd[0].toString());

          console.log(this.endDate);
          console.log(this.startDate);
          this.workTime.push(this.endDate - this.startDate);
          

          })
          // console.log(this.labelStart);
          // console.log(this.labelEnd);
          // console.log(this.workTime);
          
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