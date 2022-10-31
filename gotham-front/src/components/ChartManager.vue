<template>
  <body>
    <div class ="barChart"><canvas id="bar-chart" width="450" height="100"></canvas></div>
    <div class ="pieChart"><canvas id="pie-chart" width="300" height="100"></canvas></div>
    
  </body>
</template>

<script>
import Chart from 'chart.js/auto';
import axios from 'axios';
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
      sumWorktime: null,
    }
  },
  async mounted () {
    await this.seeWorkingTimes();
    await this.SumFuction();
    console.log(this.labelStart[15]);
    console.log(this.workTime[15]);
    new Chart(document.getElementById("bar-chart"), {
      type: 'bar',
      data: {
        labels: this.labelStart,
        color: "#3e95cd",
        datasets: [{
          data: this.workTime,
          label: "User",
          backgroundColor: "#3e95cd",
          fill: false
        }],
      },
      options: {
        scales: {
          y: {
            ticks: { color: 'white', beginAtZero: true }
          },
          x: {
            ticks: { color: 'white', beginAtZero: true }
          }
        },
        title: {
          display: true,
          text: 'Working times'
        },
        plugins: {
            legend: {
                display: true,
                labels: {
                    color: 'rgb(255, 255, 255)'
                }
            }
        }
      }
    });
    new Chart(document.getElementById("pie-chart"), {
      type: 'pie',
      data: {
        labels: ["Normal", "Night", "Sup. Hours", "Compensation"],
        datasets: [{
          label: "blablabla",
          backgroundColor: ["#48cd3e", "#453ecd", "#cdc33e", "#de2121"],
          data: [this.sumWorktime,50, 10, 4]
        }]
      },
      options: {
        title: {
          display: true,
          text: 'Hours type'
        },
        plugins: {
          legend: {
            display: true,
            position: 'right',
            labels: {
              color: 'rgb(255, 255, 255)'
            }
          }
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
          this.startDate = this.arrayStart[1];
          this.endDate = this.arrayEnd[1];
          this.labelStart.push(this.arrayStart[0].toString());
          this.labelEnd.push(this.arrayEnd[0].toString());
          this.workTime.push((new Date(_.end).valueOf() - new Date(_.start).valueOf()) / 3600000);
          
          })
          
        })
        .catch(console.error);
    },
    SumFuction() {
      console.log(this.workTime);
      this.workTime.forEach(element => {
        this.sumWorktime += element;
      });
      console.log(this.sumWorktime)
    },
  },
  watch: {
  }
}
</script>

<style scoped>
</style>