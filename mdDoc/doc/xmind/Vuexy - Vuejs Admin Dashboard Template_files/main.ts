import "/src/@iconify/icons-bundle.js";
import App from "/src/App.vue";
import layoutsPlugin from "/src/plugins/layouts.ts";
import vuetify from "/src/plugins/vuetify/index.ts";
import {loadFonts} from "/src/plugins/webfontloader.ts";
import router from "/src/router/index.ts?t=1680071238854";
import "/src/@core/scss/template/index.scss";
import "/src/styles/styles.scss";
import {createPinia} from "/node_modules/.vite/deps/pinia.js?v=26ec5296";
import {createApp} from "/node_modules/.vite/deps/vue.js?v=26ec5296";

loadFonts();
const app = createApp(App);
app.use(vuetify);
app.use(createPinia());
app.use(router);
app.use(layoutsPlugin);
app.mount("#app");

//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIkU6L2dpdGNvZGUvd2ViX3NwYWNlL3Njb3JlLXZ1ZS9zY29yZS12dWUvc3JjL21haW4udHMiXSwic291cmNlc0NvbnRlbnQiOlsiLyogZXNsaW50LWRpc2FibGUgaW1wb3J0L29yZGVyICovXHJcbmltcG9ydCAnQC9AaWNvbmlmeS9pY29ucy1idW5kbGUnXHJcbmltcG9ydCBBcHAgZnJvbSAnQC9BcHAudnVlJ1xyXG5pbXBvcnQgbGF5b3V0c1BsdWdpbiBmcm9tICdAL3BsdWdpbnMvbGF5b3V0cydcclxuaW1wb3J0IHZ1ZXRpZnkgZnJvbSAnQC9wbHVnaW5zL3Z1ZXRpZnknXHJcbmltcG9ydCB7IGxvYWRGb250cyB9IGZyb20gJ0AvcGx1Z2lucy93ZWJmb250bG9hZGVyJ1xyXG5pbXBvcnQgcm91dGVyIGZyb20gJ0Avcm91dGVyJ1xyXG5pbXBvcnQgJ0Bjb3JlL3Njc3MvdGVtcGxhdGUvaW5kZXguc2NzcydcclxuaW1wb3J0ICdAc3R5bGVzL3N0eWxlcy5zY3NzJ1xyXG5pbXBvcnQgeyBjcmVhdGVQaW5pYSB9IGZyb20gJ3BpbmlhJ1xyXG5pbXBvcnQgeyBjcmVhdGVBcHAgfSBmcm9tICd2dWUnXHJcblxyXG5sb2FkRm9udHMoKVxyXG5cclxuLy8gQ3JlYXRlIHZ1ZSBhcHBcclxuY29uc3QgYXBwID0gY3JlYXRlQXBwKEFwcClcclxuXHJcbi8vIFVzZSBwbHVnaW5zXHJcbmFwcC51c2UodnVldGlmeSlcclxuYXBwLnVzZShjcmVhdGVQaW5pYSgpKVxyXG5hcHAudXNlKHJvdXRlcilcclxuYXBwLnVzZShsYXlvdXRzUGx1Z2luKVxyXG5cclxuLy8gTW91bnQgdnVlIGFwcFxyXG5hcHAubW91bnQoJyNhcHAnKVxyXG4iXSwibWFwcGluZ3MiOiJBQUNBLE9BQU87QUFDUCxPQUFPLFNBQVM7QUFDaEIsT0FBTyxtQkFBbUI7QUFDMUIsT0FBTyxhQUFhO0FBQ3BCLFNBQVMsaUJBQWlCO0FBQzFCLE9BQU8sWUFBWTtBQUNuQixPQUFPO0FBQ1AsT0FBTztBQUNQLFNBQVMsbUJBQW1CO0FBQzVCLFNBQVMsaUJBQWlCO0FBRTFCLFVBQVU7QUFHVixNQUFNLE1BQU0sVUFBVSxHQUFHO0FBR3pCLElBQUksSUFBSSxPQUFPO0FBQ2YsSUFBSSxJQUFJLFlBQVksQ0FBQztBQUNyQixJQUFJLElBQUksTUFBTTtBQUNkLElBQUksSUFBSSxhQUFhO0FBR3JCLElBQUksTUFBTSxNQUFNOyIsIm5hbWVzIjpbXX0=