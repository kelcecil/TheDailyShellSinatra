def setup_db(context,url)
    begin
        DataMapper.setup(context,url)
    rescue => error
      puts "setupDB :: #{error}"
    end
end

def migrate_db()
  begin
    DataMapper.auto_upgrade!
  rescue => error
    puts "migrate_db():: #{error}"
  end
end

def finalize_db()
    begin
        DataMapper.finalize
    rescue
      puts "finalizeDB :: #{error}"
    end
end
