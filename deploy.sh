#/bin/bash

Usage () {
echo "Usage: $0 [OPTIONS]

Options:
	-h, --help	Print this message
	--restore	Restore backups located in the Backups_PATH variable from ./vars/vars.yaml"
}

restore="false"

if [ ! -z "$1" ]; then
  while :; do
    case "$1" in
     --restore)
      restore="true"
      break ;;
    -h | --help | *)
      Usage
      exit 1 ;;
   esac
   shift
  done
fi

ansible-playbook playbook.yaml --ask-vault-password -i inventory.yaml --extra-vars "{\"restore\": $restore}"

