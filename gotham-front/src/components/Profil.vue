<template>
  <div class="background" @click="closeProfil"></div>
  <div class="profilModal">
    <div v-if="currentUser" class="formContainer">
      <p class="title">My Account</p>
      <div class="labelInput">
        <label>email: </label>
        <input type="text" v-model="currentUser.email" />
      </div>
      <div class="labelInput">
        <label>Username: </label>
        <input type="text" v-model="currentUser.username" />
      </div>
      <div class="labelInput">
        <label>role: </label>
        {{ currentUser.roles }}
      </div>
      <div class="buttonContainer">
        <button @click="deleteUser">Delete account</button>
        <button @click="updateUser()">Update</button>
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
      users: [],
      currentUser: null,
    };
  },
  mounted() {},
  created() {
    this.getUser();
  },
  computed: {},
  methods: {
    getUser() {
      axios.get(`${import.meta.env.VITE_BACKEND_URL}/api/users/${this.idUser}`).then((res) => {
        this.currentUser = res.data.data;
      });
    },
    updateUser() {
      axios
        .put(
          `${import.meta.env.VITE_BACKEND_URL}/api/users/${this.idUser}`,
          {
            user: {
              username: this.currentUser.username,
              email: this.currentUser.email,
            },
          },
          {
            headers: {
              token: localStorage.getItem("token"),
            },
          }
        )
        .then((res) => {
          alert("Update successful");
          this.currentUser = res.data.data;
        })
        .then((res) => {
          alert("Update successful");
          this.currentUser = res.data.data;
        })
        .catch(console.error);
    },
    closeProfil() {
      this.$emit("profil");
    },
    deleteUser() {
      axios
        .delete(`${import.meta.env.VITE_BACKEND_URL}/api/users/${this.idUser}`, {
          headers: {
            token: localStorage.getItem("token"),
          },
        })
        .then((res) => {
          this.$emit("deleteuser");
        })
        .catch(console.error);
    },
  },
  watch: {},
};
</script>

<style scoped>
/* .navUser {
  background-color: rgb(173, 173, 238);
  position: relative;
  top: 0;
  width: 100%;
  border: 1px;
  height: 20vh;
}
.nav {
  justify-content: space-between;
  display: flex;
  align-items: center;
  height: 100%;
}

.box {
  display: flex;
  justify-content: center;
  width: 50vw;
}

.createUser {
  flex-direction: column;
} */

.profilModal {
  position: fixed;
  background-color: white;
  border-radius: 16px;
  width: 300px;
  /* height: 200px; */
  /* border: solid #3c4048 1px; */
  opacity: 1;
  flex: 1;
  padding: 20px;
}

.background {
  background-color: black;
  opacity: 50%;
  width: 100vw;
  height: 100vh;
  top: 0;
  left: 215px;
  display: flex;
  justify-content: center;
  align-items: center;
  position: fixed;
}
.formContainer {
  display: flex;
  flex-direction: column;
  gap: 15px;
  align-items: center;
}
.title {
  font-weight: bold;
  margin: 0;
  font-size: 25px;
}
.labelInput {
  display: flex;
  width: 80%;
  gap: 5px;
}
.buttonContainer {
  display: flex;
  justify-content: space-between;
  flex-direction: row;
  width: 70%;
}
</style>
