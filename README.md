# bloom_consul cookbook

# Requirements

# Usage

# LWRPs

## `service`

Defines a consul service.  See http://www.consul.io/docs/agent/services.html for more information regarding consul services.

### Attributes

<dl>
#### Required 
<dt>`name`</dt> <dd>`String` Service name.  If no ID is specified, it will be used for the service ID as well.  *Warning*: Each consul service must have a unique ID; adherence to this requirement is left to the caller of this resource.  The name provided at resource invocation time can be used to specify the name</dd>
<dt>`tags`</dt> <dd>`Array` of tags associated with the service.</dd>
<dt>`port`</dt> <dd>`Integer` port on which the service is listening.</dd>
#### Optional
<dt>`checks`</dt> <dd>`Hash` of service check information, containing containing keys:

 key                    |  required?   | description
 -----------------------|--------------|---------------
`script`  <sup>†</sup>  | yes (script) | name of the script to execute for a script type
`interval`<sup>†</sup>  | yes (script) | interval of script exectution for a script type
`ttl`     <sup>†</sup>  | yes (ttl)    | interval to expect API heartbeats 
`notes`                 | no           | Updated to contain API heartbeat data or script execution output; available in consul web interface  

    <em>†</em> Each check can be either a script type *or* a ttl type.  
    Each check key should contain a string value.  
    For more information regarding service checks, see http://www.consul.io/docs/agent/checks.html.
</dd>
<dt>`id`</dt> <dd>The ID of the service, if different from the `name` ( see `name` above)</dd>
</dl>

### Example

```ruby
bloom_consul_service "web-backend" do 
   tags [ "web-service-1" ]
   port 80
   checks [ 
        {   # an API-based heartbeat check
            ttl: "30s"
        },
        {   # a service-side script check
            script: "bash -c "curl -w 5 http://localhost:80/health-check",
            interval: "10s"
        }
   ]
end
```

# Attributes

All attributes are under the <code>bloom_consul</code> key.

<dl>
<dt>config_dir</dt> <dd>Configuration directory for consul, also used for service specifications</dd>
<dt>user</dt> <dd>User under whom to run consul and to whom to give file ownership</dd>
<dt>group</dt> <dd>Group for consul file ownership</dd>
</dl>


# Recipes

# Author

Author:: Dan Farrell (<dfarrell@bloomhealthco.com>)
