import requests
import json
import xlsxwriter
import time
import timeit
import pandas
from getpass import getpass
from os import system, name
from urllib3.exceptions import InsecureRequestWarning
requests.packages.urllib3.disable_warnings(category=InsecureRequestWarning)

class Vision:

    def __init__(self, ip, user, password, token=0):
        self.ip = ip
        self.username = user
        self.password = password
        self.token = token

    def connect_vision(self):

        login_path = f'https://{self.ip}/mgmt/system/user/login'
        myheaders = {'content-type': 'application/json', 'Accept': '*/*',
                     'Accept-Encoding': 'gzip, deflate, br', 'Connection': 'keep-alive'}

        payload = {
            "username": self.username,
            "password": self.password
        }

        res = requests.post(login_path, data=json.dumps(payload), verify=False,
                            headers=myheaders)
               
        if res.status_code == 401:
            print("====== Bad Login Credentials ======")
            exit(1)
        else:
            login_reposne = res.json()
            self.token = Cookie_format(login_reposne["jsessionid"])


    def Update_PO_API(self, paramas_dict):
        headers = {'content-type': 'application/json', 'Accept': '*/*',
                'Accept-Encoding': 'gzip, deflate, br', 'Connection': 'keep-alive', 'Cookie': self.token}
        add_po_url = f"https://{ self.ip }/mgmt/device/df/config/ProtectedObjects/add"

        add_po_body = {
            "name": paramas_dict["po_name"],
            "HTCPMBPS": paramas_dict["tcpm"],
            "HTCPPPS": paramas_dict["tcpp"],
            "HUDPMBPS": paramas_dict["udpm"],
            "HUDPPPS": paramas_dict["udpp"],
            "HICMPMBPS": paramas_dict["icmpm"],
            "HICMPPPS": paramas_dict["icmpp"],
            "HTOTMBPS": paramas_dict["totalm"],
            "HTOTPPS": paramas_dict["totalp"]
        }

        response = requests.put(add_po_url, data=json.dumps(
            add_po_body), verify=False, headers=headers)
        print(response)

    def Get_Po_List(self):
        headers = {'content-type': 'application/json', 'Accept': '*/*',
                   'Accept-Encoding': 'gzip, deflate, br', 'Connection': 'keep-alive', 'Cookie': self.token}
        add_po_url = f"https://{ self.ip }/mgmt/device/df/config/ProtectedObjects/"


        response = requests.get(add_po_url, verify=False, headers=headers)  
        po_dict_name = json.loads(response.text)
        list_of_pos_name = [po_dict_name["ProtectedObjects"][index]["name"] for index in range(len(po_dict_name["ProtectedObjects"]))]
        return list_of_pos_name
     

def Cookie_format(cookie_response):
    cookie_token = "JSESSIONID="+cookie_response+";"+"JSESSIONID="+cookie_response
    return cookie_token

def update_list_po():
    vision_obj = Vision(Vision_IP, Vision_User, Vision_Password)
    vision_obj.connect_vision()
    excel_data_df = pandas.read_excel('PO_Thresholds_File.xlsx')
    po_db_list = excel_data_df.to_dict(orient='record')
    po_dict_params = {}
    for index in range(len(po_db_list)):
        for key, value in po_db_list[index].items():
            po_dict_params.update({key : value})
        vision_obj.Update_PO_API(po_dict_params)
        print(f'Updating Po:{po_dict_params["po_name"]}')

def create_po_file():
    vision_obj = Vision(Vision_IP, Vision_User, Vision_Password)
    vision_obj.connect_vision()
    po_name_list = vision_obj.Get_Po_List()
   
    workbook = xlsxwriter.Workbook('PO_Thresholds_File.xlsx')
    worksheet = workbook.add_worksheet()

    # Init The PO's Excel File:
    worksheet.write(0, 0, "po_name")
    worksheet.write(0, 1, "tcpm")
    worksheet.write(0, 2, "tcpp")
    worksheet.write(0, 3, "udpm")
    worksheet.write(0, 4, "udpp")
    worksheet.write(0, 5, "icmpm")
    worksheet.write(0, 6, "icmpp")
    worksheet.write(0, 7, "totalm")
    worksheet.write(0, 8, "totalp")
    
    for row in range(1,len(po_name_list)):
        worksheet.write(row, 0, po_name_list[row])
    workbook.close()

    print("PO's Threshold file was created..")

def vision_login_prompt():
    Vision_IP = input("Please enter Vision IP: ")
    Vision_User = input("Username: ")
    Vision_Password = getpass()

    return Vision_IP, Vision_User, Vision_Password


if __name__ == "__main__":

    while True:
        print("--- Main Menu ---\n")
        print("1. Create New Po File \n2. Update existing PO's\n3. Exit\n")
        choice = int(input("Enter your choice [1-3] : "))

        if choice == 1:
            Vision_IP, Vision_User, Vision_Password = vision_login_prompt()
            create_po_file()
            break

        if choice == 2:
            Vision_IP, Vision_User, Vision_Password = vision_login_prompt()
            update_list_po()
            break

        if choice == 3:
            exit(0)
