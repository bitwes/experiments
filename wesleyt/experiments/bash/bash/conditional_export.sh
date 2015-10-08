#this will export the env variable if it has
#not been defined or has been set to ""
if [ "$COND_EXPORT" == "" ]; then
    export COND_EXPORT='ASDF'
fi
echo "COND_EXPORT = $COND_EXPORT"