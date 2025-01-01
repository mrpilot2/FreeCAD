#    Copyright (c) 2025
#
#    This file is part of the FreeCAD CAx development system.
#
#    This library is free software; you can redistribute it and/or
#    modify it under the terms of the GNU Library General Public
#    License as published by the Free Software Foundation; either
#    version 2 of the License, or (at your option) any later version.
#
#    This library  is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Library General Public License for more details.
#
#    You should have received a copy of the GNU Library General Public
#    License along with this library; see the file COPYING.LIB. If not,
#    write to the Free Software Foundation, Inc., 59 Temple Place,
#    Suite 330, Boston, MA  02111-1307, USA
#

from datetime import datetime

def generate_table_header(results):
    results.write('<table>\n\
    <thead>\n\
        <tr>\n\
            <th></th>\n\
            <th colspan="7">Linux</th>\n\
            <th colspan="7">MAC</th>\n\
            <th colspan="7">Windows</th>\n\
        </tr>\n\
        <tr>\n\
            <th></th>\n\
            <th colspan="3">PCH OFF</th>\n\
            <th colspan="3">PCH ON</th>\n\
            <th>Improvement</th>\n\
            <th colspan="3">PCH OFF</th>\n\
            <th colspan="3">PCH ON</th>\n\
            <th>Improvement</th>\n\
            <th colspan="3">PCH OFF</th>\n\
            <th colspan="3">PCH ON</th>\n\
            <th>Improvement</th>\n\
        </tr>\n\
        <tr>\n\
            <th></th>\n\
            <th>min</th>\n\
            <th>max</th>\n\
            <th>avg.</th>\n\
            <th>min</th>\n\
            <th>max</th>\n\
            <th>avg.</th>\n\
            <th>%</th>\n\
            <th>min</th>\n\
            <th>max</th>\n\
            <th>avg.</th>\n\
            <th>min</th>\n\
            <th>max</th>\n\
            <th>avg.</th>\n\
            <th>%</th>\n\
            <th>min</th>\n\
            <th>max</th>\n\
            <th>avg.</th>\n\
            <th>min</th>\n\
            <th>max</th>\n\
            <th>avg.</th>\n\
            <th>%</th>\n\
        </tr>\n\
    </thead>\n')

def start_table_body(results):
    results.write('    <tbody>\n')

def finish_table(results):
    results.write('    </tbody>\n</table>')

def generate_results_table(results, build_timings):
    
    for target, target_build_times in build_timings.items():
        results.write('        <tr>')
        results.write('        <td>' + target + '</td>\n')
        
        for architecture in ['Linux', 'MAC', 'Windows']:
            for pch in ['OFF', 'ON']:    
                times = target_build_times[architecture][pch]
                results.write('        <td>{0:.3f}s</td>'.format(min(times)))
                results.write('        <td>{0:.3f}s</td>'.format(max(times)))
                results.write('        <td>{0:.3f}s</td>'.format(sum(times)/ len(times)))

            pch_off_avg = sum(target_build_times[architecture]['OFF']) / len(target_build_times[architecture]['OFF'])
            pch_on_avg = sum(target_build_times[architecture]['ON']) / len(target_build_times[architecture]['ON'])

            improvement = (1 - pch_on_avg / pch_off_avg) * 100
            results.write('        <td><b>{0:.2f}%</b></td>'.format(improvement))
                
        results.write('        </tr>\n')
build_timings = {}

def parse_log_file(log_file, current_architecture):
    with open(log_file, 'r') as fp:
        current_target = ""
        pch = ""
        
        for row in fp:
            if "Building" in row:
                current_target = row.split("Building ")[1].split(" ")[0].strip()
                pch = row.split(" - PCH")[1].strip()
                
            if "real" in row:
                build_time = (datetime.strptime(row.split("real")[1].strip(), '%Mm%S.%fs') - datetime(1900, 1, 1)).total_seconds()
                
                if current_target not in build_timings:
                    build_timings[current_target] = {}
                
                if current_architecture not in build_timings[current_target]:
                    build_timings[current_target][current_architecture] = {}
                    
                if pch not in build_timings[current_target][current_architecture]:
                    build_timings[current_target][current_architecture][pch] = []
                    
                build_timings[current_target][current_architecture][pch].append(build_time)
                

parse_log_file('build_timings_linux.log', 'Linux')
parse_log_file('build_timings_mac.log', 'MAC')
parse_log_file('build_timings_windows.log', 'Windows')

# print(build_timings)

with open('results.md', 'w') as results:
    generate_table_header(results)
    
    start_table_body(results)
    
    generate_results_table(results, build_timings)
    
    finish_table(results)