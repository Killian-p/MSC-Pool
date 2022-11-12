<script setup>
import User from "./User.vue";
</script>
<template>
  <div style="display: flex; align-items: center; gap: 30px">
    <div style="width: 475px; align-items: center; justify-content: space-between; background-color: white; border-radius: 16px; height: 500px; padding: 15px">
      <div style="display: flex; align-items: center; align-self: center; justify-content: center">
        <p>EMPLOYEES</p>
      </div>
      <div>
        <div style="display: flex">
          <p style="display: flex; flex: 1; justify-content: center">USERNAME</p>
          <p style="display: flex; flex: 1; justify-content: center">ROLE</p>
          <p style="display: flex; flex: 1; justify-content: center">EMAIL ADDRESS</p>
        </div>
        <div style="max-height: 350px; overflow: auto">
          <div
            v-for="employee in employees.sort((a, b) => {
              return a.email > b.email;
            })"
          >
            <div :style="employee.id == selectedUserId ? 'display: flex;flex:3;justify-content: space-between;border: solid black 1px;padding: 5px 10px; border-radius: 16px;background-color: #00ABB3;' : 'display: flex;flex:3;justify-content: space-between;border: solid black 1px;padding: 5px 10px; border-radius: 16px;'" @click="selectUser(employee.id, 'employee')">
              <p style="display: flex; flex: 1; justify-content: center; margin: 0">{{ employee.username }}</p>
              <p style="display: flex; flex: 1; justify-content: center; margin: 0">{{ employee.roles }}</p>
              <p style="display: flex; flex: 1; justify-content: center; margin: 0">{{ employee.email }}</p>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div style="display: flex; justify-content: center; align-items: center; gap: 50px; flex-direction: column">
      <div>
        <button @click="setManager(selectedUserId), (this.selectedUserId = null)" id="Role1Button" :disabled="selectedUserIs != 'employee'" class="transferButtons">
          <img src="../../public/arrow-right-svgrepo-com.svg" />
        </button>
      </div>
      <div>
        <button @click="setEmployee(selectedUserId), (this.selectedUserId = null)" id="Role2Button" :disabled="selectedUserIs != 'manager'" class="transferButtons">
          <img src="../../public/arrow-left-svgrepo-com.svg" />
        </button>
      </div>
      <div>
        <button @click="deleteUser(selectedUserId)" :disabled="selectedUserId == null" style="width: 80px; height: 73px" class="transferButtons">
          <img src="../../public/trash-svgrepo-com.svg" />
        </button>
      </div>
    </div>
    <div style="width: 475px; align-items: center; justify-content: space-between; background-color: white; border-radius: 16px; height: 500px; padding: 15px">
      <div style="display: flex; align-items: center; align-self: center; justify-content: center">
        <p>MANAGERS</p>
      </div>
      <div>
        <div style="display: flex;">
          <p style="display: flex; flex: 1; justify-content: center">USERNAME</p>
          <p style="display: flex; flex: 1; justify-content: center">ROLE</p>
          <p style="display: flex; flex: 1; justify-content: center">EMAIL ADDRESS</p>
        </div>
        <div style="max-height: 350px; overflow: auto">
          <div
            v-for="employee in managers.sort((a, b) => {
              return a.email > b.email;
            })"
          >
            <div :style="employee.id == selectedUserId ? 'display: flex;flex:3;justify-content: space-between;border: solid black 1px;padding: 5px 10px; border-radius: 16px;background-color: #00ABB3;' : 'display: flex;flex:3;justify-content: space-between;border: solid black 1px;padding: 5px 10px; border-radius: 16px;'" @click="selectUser(employee.id, 'manager')">
              <p style="display: flex; flex: 1; justify-content: center; margin: 0">{{ employee.username }}</p>
              <p style="display: flex; flex: 1; justify-content: center; margin: 0">{{ employee.roles }}</p>
              <p style="display: flex; flex: 1; justify-content: center; margin: 0">{{ employee.email }}</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";
export default {
  props: {},
  data() {
    return {
      datas: null,
      selectedUserId: null,
      employees: [],
      managers: [],
      selectedUserIs: null,
    };
  },
  mounted() {
    this.getUsers();
  },
  created() {},
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
          this.employees = res.data.data.filter((elem) => elem.roles === "EMPLOYEE");
          this.managers = res.data.data.filter((elem) => elem.roles === "MANAGER");
        })
        .catch(console.error);
    },

    setManager(id) {
      axios
        .put(
          `${import.meta.env.VITE_BACKEND_URL}/api/users/${id}`,
          {
            user: {
              roles: "MANAGER",
            },
          },
          {
            headers: {
              token: localStorage.getItem("token"),
            },
          }
        )
        .then((res) => {
          this.employees = this.employees.filter((elem) => elem.id !== res.data.data.id);
          this.managers.push(res.data.data);
        })
        .catch(console.error);
      this.selectedUserIs = null;
    },
    setEmployee(id) {
      axios
        .put(
          `${import.meta.env.VITE_BACKEND_URL}/api/users/${id}`,
          {
            user: {
              roles: "EMPLOYEE",
            },
          },
          {
            headers: {
              token: localStorage.getItem("token"),
            },
          }
        )
        .then((res) => {
          this.managers = this.managers.filter((elem) => elem.id !== res.data.data.id);
          this.employees.push(res.data.data);
        })
        .catch(console.error);
      this.selectedUserIs = null;
    },
    selectUser(id, role) {
      this.selectedUserId = id;
      this.selectedUserIs = role;
    },
    removeUserFromTables(idUser, role) {
      if (role == "employee") {
        this.employees = this.employees.filter((elem) => elem.id !== idUser);
      }
      if (role == "") this.managers = this.managers.filter((elem) => elem.id !== idUser);
    },
    deleteUser(id) {
      axios
        .delete(`${import.meta.env.VITE_BACKEND_URL}/api/users/${id}`, {
          headers: {
            token: localStorage.getItem("token"),
          },
        })
        .then((res) => {
          this.removeUserFromTables(id, this.selectedUserIs);
          this.selectedUserId = null;
          this.selectedUserIs = null;
        })
        .catch(console.error);
    },
  },
  watch: {},
};
</script>
<style scoped>
.transferButtons {
  border-radius: 16px;
  background-color: white;
  color: #00abb3;
  cursor: pointer;
}

.transferButtons:hover {
  background-color: #d9d9d9;
  color: #3c4048;
}

.transferButtons:disabled {
  background-color: white;
  cursor: default;
}
</style>
