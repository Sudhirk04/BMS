@REM Copyright (c) 2010 - 2021, Fraunhofer-Gesellschaft zur Foerderung der angewandten Forschung e.V.
@REM All rights reserved.
@REM
@REM SPDX-License-Identifier: BSD-3-Clause
@REM
@REM Redistribution and use in source and binary forms, with or without
@REM modification, are permitted provided that the following conditions are met:
@REM
@REM 1. Redistributions of source code must retain the above copyright notice, this
@REM    list of conditions and the following disclaimer.
@REM
@REM 2. Redistributions in binary form must reproduce the above copyright notice,
@REM    this list of conditions and the following disclaimer in the documentation
@REM    and/or other materials provided with the distribution.
@REM
@REM 3. Neither the name of the copyright holder nor the names of its
@REM    contributors may be used to endorse or promote products derived from
@REM    this software without specific prior written permission.
@REM
@REM THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
@REM AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
@REM IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
@REM DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
@REM FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
@REM DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
@REM SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
@REM CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
@REM OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
@REM OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
@REM
@REM We kindly request you to use one or more of the following phrases to refer to
@REM foxBMS in your hardware, software, documentation or advertising materials:
@REM
@REM - "This product uses parts of foxBMS&reg;"
@REM - "This product includes parts of foxBMS&reg;"
@REM - "This product is derived from foxBMS&reg;"

@SETLOCAL EnableExtensions EnableDelayedExpansion

@TITLE foxBMS Development Console

@CALL %~dp0\tools\utils\cmd\find_git.bat

@IF DEFINED GIT_DIR (
    @set "PATH=%GIT_DIR%;%PATH%"
)

@FOR /F "usebackq tokens=*" %%A in ("%~dp0\conf\env\paths_win32.txt") do @(
    @IF exist %%A (
        @CALL set "NewPath=%%NewPath%%;%%A"
    )
)
@IF DEFINED NewPath (
    @SET "PATH=%NewPath:~1%;%PATH%"
)

@SET CONDA_BASE_ENVIRONMENT_ACTIVATE_SCRIPT=""
@CALL %~dp0\tools\utils\cmd\find_base_conda.bat

@IF %CONDA_BASE_ENVIRONMENT_ACTIVATE_SCRIPT%=="" (
    pause
    @EXIT /b 1
)

@CALL %CONDA_BASE_ENVIRONMENT_ACTIVATE_SCRIPT% %CONDA_DEVELOPMENT_ENVIRONMENT_NAME%

@REM Check for VS Code
@CALL %~dp0\tools\utils\cmd\find_vs-code.bat
@IF NOT DEFINED VS_CODE @(
    @ECHO [31mCould not find VS Code.[0m
    @ECHO VS Code can be downloaded at https://code.visualstudio.com/.
    @PAUSE
    @EXIT /b 2
)
@IF %VS_CODE%=="" @(
    @ECHO [31mCould not find VS Code.[0m
    @ECHO VS Code can be downloaded at https://code.visualstudio.com/.
    @PAUSE
    @EXIT /b 1
)

@PUSHD %~dp0
@start "foxBMS Development" /b %VS_CODE% .
@IF %ERRORLEVEL% NEQ 0 (
    @EXIT /b %ERRORLEVEL%
) ELSE (
    @conda deactivate
)
@POPD
