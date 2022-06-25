addEventListener("message",(e)=>{
    let data = e.data;

    if(data.action == true){
        $("#main-container").fadeIn();
        $("#main-container").html("");
        for(const vehicle of data.vehicleInfo){
            if(vehicle.pricing){
                let html = `
                <div data-view=${vehicle.model} class="vehicle">
                <div class="vehicle-name">${vehicle.label} <div class="vehicle-price">($${vehicle.price.toLocaleString()})</div></div>
                    <div class="vehicle-icon" data-model=${vehicle.model} data-model=${vehicle.label} data-price=${vehicle.price} data-garage=${vehicle.garage}><i class="fas fa-arrow-circle-right"></i></div>
                </div>
                `
                $("#main-container").append(html);
            } else {
                let html = `
                <div data-view=${vehicle.model} class="vehicle">
                    <div class="vehicle-name">${vehicle.label}</div>
                    <div class="vehicle-icon" data-model=${vehicle.model} data-model=${vehicle.label} data-garage=${vehicle.garage}><i class="fas fa-arrow-circle-right"></i></div>
                </div>
                `
                $("#main-container").append(html);
            }
        }
        $(".vehicle-icon").click(function() {
            let model = $(this).data("model");
            let label = $(this).data("label");
            let price = $(this).data("price");
            let garage = $(this).data("garage");
            // $("#main-container").fadeOut()
            $.post("https://ik-jobgarage/buy",JSON.stringify({model,label,price,garage}));
        
        })
        let lastmodel = 0;

        $(".vehicle").click(function() {
            let model = $(this).data("view");
            let garage = $(".vehicle-icon").data("garage");
            if(lastmodel != model){
                lastmodel = model
                $.post("https://ik-jobgarage/showVeh",JSON.stringify({model,garage}));
            }
        })
    } else if(data.action == "close") {
        $("#main-container").fadeOut()
        $.post("https://ik-jobgarage/close",JSON.stringify({}));
    }
})


document.onkeydown = (e) =>{
    let key = e.key;
    if(key == "Escape"){

        $("#main-container").fadeOut()
        $.post("https://ik-jobgarage/close",JSON.stringify({}));
    }
}