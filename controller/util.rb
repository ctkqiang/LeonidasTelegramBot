class Util
    def method_name
        if RUBY_PLATFORM =~ /win32|win64|\.NET|windows|cygwin|mingw32/i
            system("cls")
        else
            system("clear")
        end
    end
end