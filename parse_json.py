import json
from os import makedirs
from os.path import exists
import sys


def write_file(data: list, file_path: str):
    data = [str(d) + "\n" for d in data]
    with open(file_path, mode='w+', encoding='utf-8') as f:
        f.writelines(data)


def get_path(x):
    return f"./output/{folder_names[x]}/"


class ParseJson:
    def __init__(self, file_path: str):
        # read the logs as lines
        with open(file_path, mode='r', encoding='utf-8') as f:
            self.lines = f.readlines()
            self.lines = [ln for ln in self.lines if ln.strip() != '']
        # make dirs

    def proc_info(self):
        args, exe, pid, ppid = [], [], [], []
        for line in self.lines:
            try:
                obj = json.loads(line)
                process = obj["process"]
                args.append(' '.join(process["args"]))
                exe.append(process["name"])
                pid.append(process["pid"])
                ppid.append(process["ppid"])
            except KeyError:
                # windows timing report & file integrity service by beat
                continue
            except ValueError as err:
                print(err)
        return args, exe, pid, ppid


if __name__ == '__main__':
    log_file = sys.argv[1]
    folder_names = {"proc": "procinfo"}
    parser = ParseJson(log_file)
    procinfo = parser.proc_info()

    if not exists(get_path("proc")):
        makedirs(get_path("proc"))
    for index, file_name in enumerate(["args", "exe", "pid", "ppid"]):
        path = get_path("proc") + file_name + ".txt"
        write_file(procinfo[index], path)
        print(path)
