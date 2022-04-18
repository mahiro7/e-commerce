import Quill from 'quill';

export let TextEditor = {
    mounted() {
        console.log('Mounting');

        this.el.phxHookId = 1;

        let quill = new Quill(this.el, {
            theme: 'snow'
        });

        description = document.getElementById("editor").getAttribute("value");

        quill.setContents(JSON.parse(description));

        quill.on('text-change', (delta, oldDelta, source) => {
            if (source == 'api') {
                console.log('An API call triggered this change');
            } else if (source == 'user') {
                console.log(this);

                this.pushEventTo(this.el.phxHookId, "text-editor", {"text_content": quill.getContents()})
            }
        });
    },
    updated(){
        console.log('U');
    }
}
