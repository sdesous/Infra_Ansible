#!/usr/bin/python

# Copyright: (c) 2018, Terry Jones <terry.jones@example.org>
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)
from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

DOCUMENTATION = r'''
---
module: subuid_or_subgid

short_description: This is my test module

# If this is part of a collection, you need to use semantic versioning,
# i.e. the version is of the form "2.5.0" and not "2.4".
version_added: "1.0.0"

description: This is my longer description explaining my test module.

options:
    username:
        description: This is the username used.
        required: true
        type: str
'''

EXAMPLES = r'''
# pass in a message and have changed true
- name: Test with a message and changed output
  subuid_or_subgid:
    username: hello world
'''

RETURN = r'''
# These are examples of possible return values, and in general should use other names for return values.
new_line:
    description: The line added.
    type: str
    returned: always
    sample: 'user:100000:65536'
'''

from ansible.module_utils.basic import AnsibleModule


def run_module():
    # define available arguments/parameters a user can pass to the module
    module_args = dict(
        username=dict(type='str', required=True),
    )

    # seed the result dict in the object
    # we primarily care about changed and state
    # changed is if this module effectively modified the target
    # state will include any data that you want your module to pass back
    # for consumption, for example, in a subsequent task
    result = dict(
        changed = False,
        new_line = ""
    )

    # the AnsibleModule object will be our abstraction working with Ansible
    # this includes instantiation, a couple of common attr would be the
    # args/params passed to the execution, as well as if the module
    # supports check mode
    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=True
    )

    last_line = open('/etc/subuid','r').read()
    if module.params["username"] not in [x.split(':')[0] for x in last_line.split('\n')[:-1]] :
        if last_line == "":
            new_value = "100000"
        else:
            last_line = last_line.split('\n')[-2].split(':')[1]
            new_value = int(last_line) + 65536 + 1

        result["new_line"] = ':'.join([module.params["username"], str(new_value), "65536"])

        with open('/etc/subuid','a') as f:
            f.write(result["new_line"] + '\n')
            result["changed"] = True

        with open('/etc/subgid','a') as f:
            f.write(result["new_line"] + '\n')
            result["changed"] = True

    # if the user is working with this module in only check mode we do not
    # want to make any changes to the environment, just return the current
    # state with no modifications
    if module.check_mode:
        module.exit_json(**result)

    # in the event of a successful module execution, you will want to
    # simple AnsibleModule.exit_json(), passing the key/value results
    module.exit_json(**result)


def main():
    run_module()


if __name__ == '__main__':
    main()