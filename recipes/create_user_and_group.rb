
group node[:bloom_consul][:group]

user node[:bloom_consul][:user] do
    gid node[:bloom_consul][:group]
    system
end
