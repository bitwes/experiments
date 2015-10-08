require 'chef/resource'

class RemoteZipSync < Chef::Resource
  
=begin  
  def sync(remote_url, zip_name, staging_dir, local_dir)
    if isRemoteNewer(remote_url, zip_name, staging_dir)
      getRemoteZip(remote_url + zip_name, staging_dir)
      unzip(zip_name, staging_dir)
      syncUnzippedWithLocal(staging_dir, local_dir)
    end
  end


  def getRemoteZip(remote_zip, staging_dir)
      `wget #{remote} #{staging_dir}`
  end


  def unzip(zip_name, staging_dir)
    `rm -rf #{staging_dir}/staged`
    `unzip -u #{staging_dir}#{zip_name} -d #{staging_dir}/staged`
  end


  def syncUnzippedWithLocal(staging_dir, local_dir)
    `rsync #{staging_dir}staged #{local_dir}`
  end


  def isRemoteNewer(remote_url, zip_name, staging_dir)
    toReturn = false
    if File.exist?(staging_dir + zip_name)
      local_modified = File.ctime(local)
      last_modified = `curl -I #{remote_url}#{remote_zip} | grep Last-Modified 2>/dev/null`
      last_modified = last_modified.split("Last-Modified: ")[1].rstrip()
      bucket_modified = Time.strptime(last_modified, '%a, %e %b %Y %H:%M:%S %Z')
      
      toReturn = bucket_modified > local_modified
    else
      toReturn = true
    end

    return toReturn
  end
=end
  
  def put_it (to_put)
    puts(to_put + "\n")
  end
  #private :getRemoteZip
end
