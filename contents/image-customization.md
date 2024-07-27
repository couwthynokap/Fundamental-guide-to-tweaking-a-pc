# Image Customization

## Requirements

- Extraction tool - [7-Zip](https://www.7-zip.org) is recommended

- [Windows ADK](https://docs.microsoft.com/en-us/windows-hardware/get-started/adk-install) - Install Deployment Tools

## Preparing the Build Environment

- If you have real-time protection enabled in Windows Defender, you can temporarily disable it to speed up the mounting and dismounting process. In some cases, real-time protection can slow down these processes or cause problems.

- Open Command Prompt as administrator and keep the window open. We'll be setting temporary environment variables that will disappear when you close the window. 

- Run the command provided. If you encounter an error, close the Command Prompt and reopen it as administrator again. If nothing appears in the output after running the command, proceed to the next step.

    ```bat
    DISM > nul 2>&1 || echo error: administrator privileges required
    ```

- Extract the contents of the ISO to a directory of your choice then assign it to the ``EXTRACTED_ISO`` variable. In the examples below, I'm using ``C:\en_windows_7_professional_with_sp1_x64_dvd_u_676939``

    ```bat
    set "EXTRACTED_ISO=C:\en_windows_7_professional_with_sp1_x64_dvd_u_676939"
    ```

- Set the path where the ISO will be mounted for servicing to the ``MOUNT_DIR`` variable. Changing the value below isn't necessary

    ```bat
    set "MOUNT_DIR=%temp%\MOUNT_DIR"
    ```

- Set the path to the ``oscdimg.exe`` binary to the ``OSCDIMG`` variable. Unless you installed deployment tools to a location other than the default, changing the value below isn't necessary

    ```bat
    set "OSCDIMG=C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg\oscdimg.exe"
    ```

- Prepare the ``MOUNT_DIR`` directory for mounting

    ```bat
    > nul 2>&1 (DISM /Unmount-Wim /MountDir:"%MOUNT_DIR%" /Discard & rd /s /q "%MOUNT_DIR%" & mkdir "%MOUNT_DIR%")
    ```

- If the environment variables are configured correctly, the commands below should all display ``true``

    ```bat
    if exist "%EXTRACTED_ISO%\sources\install.wim" (echo true) else (echo false)
    ```

    ```bat
    if exist "%MOUNT_DIR%" (echo true) else (echo false)
    ```

    ```bat
    if exist "%OSCDIMG%" (echo true) else (echo false)
    ```

## Removing Non-Essential Editions

We need to keep only the desired edition. To do this, we'll identify the indexes of all the other editions and remove them using the commands below. After this process, the desired edition should be the only one remaining, located at index 1.

- Let's list all the available editions and find out their corresponding numbers (indexes).

    ```bat
    DISM /Get-WimInfo /WimFile:"%EXTRACTED_ISO%\sources\install.wim"
    ```

- Remove edition by index. Replace ``<index>`` with the index number

    ```bat
    DISM /Delete-Image /ImageFile:"%EXTRACTED_ISO%\sources\install.wim" /Index:<index>
    ```

## Mounting the ISO

Mount the ISO with the command below.

```bat
DISM /Mount-Wim /WimFile:"%EXTRACTED_ISO%\sources\install.wim" /Index:1 /MountDir:"%MOUNT_DIR%"
```

## Integrating Drivers

Place all the drivers that you want to integrate (if any) in a folder such as ``C:\drivers`` and use the command below to integrate them into the mounted ISO.

```bat
DISM /Image:"%MOUNT_DIR%" /Add-Driver /Driver:"C:\drivers" /Recurse /ForceUnsigned
```

## Integrating Updates

Integrate the updates into the mounted ISO with the command below. The servicing stack must be installed before installing any cumulative updates.

```bat
DISM /Image:"%MOUNT_DIR%" /Add-Package /PackagePath=<path\to\update>
```

## Enabling .NET 3.5 (Windows 8+)

.NET 3.5 can be enabled using the command below which a minority of applications depend on.

```bat
DISM /Image:"%MOUNT_DIR%" /Enable-Feature /FeatureName:NetFx3 /All /LimitAccess /Source:"%EXTRACTED_ISO%\sources\sxs"
```

## Modifying ISO Contents

To modify the ISO contents, the directory can be opened with the command below.

```bat
explorer "%MOUNT_DIR%"
```

## Unmounting and Saving Changes

Run the command below to commit our changes to the ISO. If you get an error, check if the directory is empty to ensure the ISO is unmounted by typing ``explorer "%MOUNT_DIR%"``. If it is empty, you can likely ignore the error, otherwise try closing all open folders and running the command again.

```bat
DISM /Unmount-Wim /MountDir:"%MOUNT_DIR%" /Commit && rd /s /q "%MOUNT_DIR%"
```

## ISO Compression

Compressing has no advantage other than reducing the size. Keep in mind that Windows setup must decompress the ISO upon installation which takes time. Use the command below to compress the ISO.

```bat
DISM /Export-Image /SourceImageFile:"%EXTRACTED_ISO%\sources\install.wim" /SourceIndex:1 /DestinationImageFile:"%EXTRACTED_ISO%\sources\install.esd" /Compress:recovery /CheckIntegrity && del /f /q "%EXTRACTED_ISO%\sources\install.wim"
```

## Convert to ISO

Use the command below to pack the extracted contents back to a single ISO which will be created in the ``C:\`` drive.

```bat
"%OSCDIMG%" -m -o -u2 -udfver102 -l"Final" -bootdata:2#p0,e,b"%EXTRACTED_ISO%\boot\etfsboot.com"#pEF,e,b"%EXTRACTED_ISO%\efi\microsoft\boot\efisys.bin" "%EXTRACTED_ISO%" "C:\Final.iso"
```

