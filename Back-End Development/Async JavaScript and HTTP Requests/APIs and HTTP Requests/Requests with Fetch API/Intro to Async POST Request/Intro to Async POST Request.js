/*
Intro to async POST Requests
Now that you’ve
Now that you’ve made an async GET request, let’s start getting familiar with the async POST request.

As we’ve seen before, a POST request requires more information. Take a look at the diagram to the right.

We still have the same structure of using try and catch as the async GET request we just learned about. But, in the fetch() call, we now have to include an additional argument that contains more information like method and body.

The method property value is set to 'POST' to specify the type of request we are making. Then we have to include a body property with the value of JSON.stringify({id: 200}).

// async await POST
const getData = async()=>{
    try{
        const response = await fetch("https://api-to-call.com/endpoint", {
            method: "POST",
            body: JSON.stringify({id: 200})
        })
        if(response.ok){
            const jsonResponse = await response.json();
            // Code to execute with jsonResponse
        }

    }catch(error){
        console.log(error);
    }
}

*/