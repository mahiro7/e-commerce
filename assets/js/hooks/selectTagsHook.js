import jQuery from "jquery"
import $ from "jquery"
import select2 from "select2"
select2($)


export let SelectTags = {
    initSelect2() {
      let hook = this,
          $select = jQuery(hook.el).find("select");
    
      $select.select2({
        tags: true
      })
      .on("select2:select", (e) => hook.selected(hook, e))
      .on("change", (e) => hook.changed(hook, e))
    
      return $select;
    },

    mounted() {
      this.initSelect2();
      tags = $('#product-form_tags').select2('val')
      this.pushEventTo("#product-form_tags", "change_tags", tags)
    },

    selected(hook, event) {
      let id = event.params.data.id;
    },

    changed(hook, event) {
      tags = $('#product-form_tags').select2('val')
      this.pushEventTo("#product-form_tags", "change_tags", tags)
    }
}