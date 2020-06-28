#                                                                                                                            
# ADDDONS
#                                                                                                                            


# Set the global var __PROGRAM__ at the beginning of your scripts                                                           
# USE: __PROGRAM__=`basename $0`                                                                                            
                                                                                                                        
                                                                                                    
function GetDatetime(){                                                                                                     
    printf "time=%s" $(date +%Y%m%dT%H%M%SZ)                                                                                  
}                                                                                                                           
                                                                                                                            
function Step() {                                                                                                           
    echo ""                                                                                                                   
    echo "$(GetDatetime) -> $__PROGRAM__: $*"
}                                                                                                                           
                                                                                                                            
function Task() {                                                                                                   
    echo "$(GetDatetime)   - $__PROGRAM__: $* ..."
}                                                                                                                           
                                                                                                                            
function Log() {                                                                                                            
    if [[ $__DEBUG_MODE_ENABLED__ == "true" ]]; then                                                                          
        echo "$(GetDatetime)   : $__PROGRAM__: $*"
    fi;                                                                                                                       
}                                                                                                                           
                                                                                                                            
function Err() {                                                                                                            
    echo "$(GetDatetime) <- $__PROGRAM__: ERROR - $*"
    exit 1                                                                                                                    
}                                                                                                                           
                                                                                                                            
function Done() {                                                                                                           
    echo "$(GetDatetime) <- $__PROGRAM__: Done."
    echo ""                                                                                                                   
}                                                                                                                      
                                                                                                                            
                                                                                                                            
# check_errors: Check if the previous command fails                                                                         
# params                                                                                                                    
#   - retcode int                                                                                                           
function Check() {                                                                                                          
local _code=$1                                                                                                            
shift                                                                                                                     
local _message="${*}"                                                                                                     
if [[ $_code != 0 ]]; then                                                                                                
    Err "$_message"                                                                                                         
    exit 1                                                                                                                  
else                                                                                                                      
    Log "No errors"                                                                                                         
fi;                                                                                                                       
}                                                                                                                           
                                                                                                                    
