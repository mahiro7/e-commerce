import jQuery from "jquery"
import $ from "jquery"
import select2 from "select2"
select2($)


export let SelectCategory = {
    initSelect2() {
      let hook = this,
          $select = jQuery(hook.el).find("select");
    
      $select.select2({
        tags: true
      })
      .on("select2:select", (e) => hook.selected(hook, e))
    
      return $select;
    },

    mounted() {
      this.initSelect2();
    },

    selected(hook, event) {
      let id = event.params.data.id;
      //hook.pushEvent("category_selected", {category: id})
    }
}