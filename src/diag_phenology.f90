program diag_phenology
  use netcdf
  implicit none

  integer, parameter :: nx=40 , ny=40, nz=32, nt=93, nv=3

  real(kind=8), dimension(nx,ny,nz,nt) :: var
  real(kind=8), dimension(nx,ny,nz) :: phenology
  real(kind=8), dimension(nt) :: time
  character(len=80), dimension(nv) :: listvar

  integer :: ios, ncidw, ncidr
  integer :: ix, iy, iz, it, iv
  integer :: idx, idy, idz, idt, idv
  integer, dimension(nv) :: idp
  character(len=80) :: varname, phname
  integer :: ktmin, ktmax
  real(kind=8) :: vmin, vmax, vph

  listvar(1)='CHL'
  listvar(2)='ZOO'
  listvar(3)='ZOO2'

  ! Create output file
  ios = NF90_CREATE("tmpfile_o.nc",NF90_CLOBBER,ncidw)
  ios = NF90_DEF_DIM(ncidw,'x',nx,idx)
  ios = NF90_DEF_DIM(ncidw,'y',ny,idy)
  ios = NF90_DEF_DIM(ncidw,'deptht',nz,idz)
  do iv=1,nv
    phname='ph'//listvar(iv)
    ios = NF90_DEF_VAR(ncidw,phname,NF90_FLOAT,(/idx,idy,idz/),idp(iv))
  enddo
  ios = NF90_ENDDEF(ncidw)

  ! Loop on variables
  do iv=1,nv
    varname=listvar(iv)

    ! Read variable in input file
    ios = NF90_OPEN('tmpfile_i.nc',NF90_NOWRITE,ncidr)
    if (ios.NE.0) stop 'error reading NetCDF file 1'
    ios = NF90_INQ_VARID(ncidr,'time_counter',idt)
    if (ios.NE.0) stop 'error reading NetCDF file 2'
    ios = NF90_INQ_VARID(ncidr,varname,idv)
    if (ios.NE.0) stop 'error reading NetCDF file 3'
    ios = NF90_GET_VAR(ncidr,idt,time)
    if (ios.NE.0) stop 'error reading NetCDF file 4'
    ios = NF90_GET_VAR(ncidr,idv,var)
    if (ios.NE.0) stop 'error reading NetCDF file 5'
    ios = NF90_CLOSE(ncidr)
    if (ios.NE.0) stop 'error reading NetCDF file 6'

    !print *, 'variable :,',varname
    !print *, 'minimum :,',minval(var)
    !print *, 'maximum :,',maxval(var)

    ! Compute phenology
    do iz=1,nz
    do iy=1,ny
    do ix=1,nx
      ktmax = maxloc( var(ix,iy,iz,:), 1 )
      ktmin = minloc( var(ix,iy,iz,:ktmax), 1 )
      vmax = var(ix,iy,iz,ktmax)
      vmin = var(ix,iy,iz,ktmin)
      vph = ( vmax + vmin ) / 2
      timeloop : do it=ktmin,ktmax
        if (var(ix,iy,iz,it).GE.vph) then
          phenology(ix,iy,iz) = time(it)
          exit timeloop
        endif
      enddo timeloop
    enddo
    enddo
    enddo

    ! Write phenology for current variable
    ios = NF90_PUT_VAR(ncidw,idp(iv),phenology)
  enddo

  ! Close output file
  ios = NF90_CLOSE(ncidw)
end program diag_phenology
