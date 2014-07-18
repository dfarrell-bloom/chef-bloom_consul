# bloom_consul cookbook

# Requirements

The cookbook is meant for use on Ubunto 12.04.  It probably supports most Debian derivatives.  

Since it uses a `.deb` file to distribute consul, it probably won't work as-is on other systems. 

# Usage

Typical usage is to define the configuration attributes ( see under Attributes below ), noteably: 
* whether node is server or client
* bootstrap?
Most consul defaults are usually appropriate.  

The default recipe can then be executed to install the node as configured.

## Specifying services

There is a LWRP to define each service; see below.  

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

## configure

The configuration LWRP is used as a convenient means to sanitize configuration settings.  Though it can be invoked directly, it would generally be called by the `configure` recipe to configure consul.

### Attributes

Nearly every configuration parameter is mapped to a key in `node[:bloom_consul][:config]`.  Leaving the parameter set to `nil` will avoid specifying a value, letting consul use its default instead.  

The configure provider automatically loads each attribute as an argument to the appropriate `configure` resource parameter.

# Attributes

All attributes are under the <code>bloom_consul</code> key.

<dl>
<dt>config_dir</dt> <dd>Configuration directory for consul, also used for service specifications</dd>
<dt>user</dt> <dd>User under whom to run consul and to whom to give file ownership</dd>
<dt>group</dt> <dd>Group for consul file ownership</dd>
<dt>veresion</dt> <dd>The version of consul to deploy (there must be a corresponding `.deb` file)</dd>
<dt>url</dt> <dd>The location of the debfile to download.  You can point to a different URL, and build a new `.deb` file with the cookbook in `test/fixtures/`.
</dl>

Nearly every configuration variable has an attribute under `node[:bloom_consul][:config]`.  For a list, see `attributes/default.rb`.  The names correspond exactly to the configuration parameters they control ( see http://www.consul.io/docs/agent/options.html ).

# Recipes

## default.rb

includes the service, install, install_checks and configure recipes to provide a default consul installation recipe.  This recipe is sufficient for most uses ( eg installing consul ).

## configure.rb

This recipe rewrites a consul configuration using the settings specified in the node's attributes within `node[:bloom_consul][:config]`.  
## create_user_and_group.rb

User and group will be created based on `node[:consul][:user]` and `node[:consul][:group]`.  

## install.rb

Consul will be installed from the specified remote deb file.  Within `test/fixtures` exists a cookbook capable of building this deb file and some basic instructions for how one might publish it.  The deb file set in the default attributes should be sufficient for most purposes.

## install_checks.rb

Installs scripts that can be used to check whether services are available.  Currently only installs one check , which can be found in `files/default/http-status-check.sh`.  

## service.rb

Defines a consul service so that it can be started/restarted in the other recipes. This recipe itself does not handle the service state, it just defines it (in other words, the action is `:nothing`).  

# Author

Author:: Dan Farrell (<dfarrell@bloomhealthco.com>)
