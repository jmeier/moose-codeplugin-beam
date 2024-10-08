# Test for small strain Timoshenko beam bending in y direction

# A unit load is applied at the end of a cantilever beam of length 4m.
# The properties of the cantilever beam are as follows:
# Young's modulus (E) = 2.60072400269
# Shear modulus (G) = 1.00027846257
# Poisson's ratio (nu) = 0.3
# Shear coefficient (k) = 0.85
# Cross-section area (A) = 0.554256
# Iy = 0.0141889 = Iz
# Length = 4 m

# For this beam, the dimensionless parameter alpha = kAGL^2/EI = 204.3734

# The small deformation analytical deflection of the beam is given by
# delta = PL^3/3EI * (1 + 3.0 / alpha) = 5.868e-4 m

# Using 10 elements to discretize the beam element, the FEM solution is 5.852e-2m.
# This deflection matches the FEM solution given in Prathap and Bhashyam (1982).

# References:
# Prathap and Bhashyam (1982), International journal for numerical methods in engineering, vol. 18, 195-210.
# Note that the force is scaled by 1e-4 compared to the reference problem.

[Mesh]

  type = GeneratedMesh
  dim = 1
  nx = 5
 xmin = 0.0
  xmax = 4
   ymin = 0.0
  ymax = 0.0
   zmin = 0.0
  zmax = 0
  displacements = 'disp_x disp_y disp_z'
  elem_type=EDGE3
[]

[Variables]
  [./disp_x]
    order =  SECOND
    family = LAGRANGE
  [../]
  [./disp_y]
    order =  SECOND
    family = LAGRANGE
  [../]
  [./disp_z]
    order =  SECOND
    family = LAGRANGE
  [../]
  [./rot_x]
    order =  SECOND
    family = LAGRANGE
  [../]
  [./rot_y]
    order =  SECOND
    family = LAGRANGE
  [../]
  [./rot_z]
    order =  SECOND
    family = LAGRANGE
  [../]
[]

[AuxVariables]
  [fx]
  order=CONSTANT
    family = MONOMIAL
  []
  [fy]
  order=CONSTANT
    family = MONOMIAL
  []
   [fz]
   order=CONSTANT
    family = MONOMIAL
  []
    [Mz]
    family = MONOMIAL
  []
[]

[AuxKernels]
  [fx]
    type = MaterialRealVectorValueAux
    property = beam_forces
    variable = fx
    component = 0
  []

    [fy]
    type = MaterialRealVectorValueAux
    property = beam_forces
    variable =fy
    component = 1
  []

     [fz]
    type = MaterialRealVectorValueAux
    property = beam_forces
    variable =fz
    component = 2
  []
  [Mz]
     type = MaterialRealVectorValueAux
    property = beam_moments
    variable = Mz
    component = 2
  []
  []

[BCs]
  [./fixx1]
    type = DirichletBC
    variable = disp_x
    boundary = left
    value = 0.0
  [../]
  [./fixy1]
    type = DirichletBC
    variable = disp_y
    boundary = left
    value = 0.0
  [../]
  [./fixz1]
    type = DirichletBC
    variable = disp_z
    boundary = left
    value = 0.0
  [../]
  [./fixr1]
    type = DirichletBC
    variable = rot_x
    boundary = left
    value = 0.0
  [../]
  [./fixr2]
    type = DirichletBC
    variable = rot_y
    boundary = left
    value = 0.0
  [../]
  [./fixr3]
    type = DirichletBC
    variable = rot_z
    boundary = left
    value = 0.0
  [../]

[]

[NodalKernels]
  [./force_y2]
    type = ConstantRate
    variable = disp_y
    boundary = right
    rate = 1e-4
  [../]
[]

[Preconditioning]
  [./smp]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  type = Transient
  solve_type =NEWTON
   petsc_options = '-snes_ksp_ew'  #'-ksp_view_pmat'

  # best overall
  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  petsc_options_value = ' lu       mumps'


  line_search = 'none'
  nl_max_its = 56
  l_max_its = 20
  nl_rel_tol = 1e-10
  nl_abs_tol = 1e-10

  dt = 1
  dtmin = 1
  end_time = 1
  []

[Kernels]
  [./solid_disp_x]
    type = StressDivergenceCurvedBeam

    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    component = 0
    variable = disp_x
  [../]
  [./solid_disp_y]
    type = StressDivergenceCurvedBeam

    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    component = 1
    variable = disp_y
  [../]
  [./solid_disp_z]
    type = StressDivergenceCurvedBeam

    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    component = 2
    variable = disp_z
  [../]
  [./solid_rot_x]
    type = StressDivergenceCurvedBeam

    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    component = 3
    variable = rot_x
  [../]
  [./solid_rot_y]
    type = StressDivergenceCurvedBeam

    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    component = 4
    variable = rot_y
  [../]
  [./solid_rot_z]
    type = StressDivergenceCurvedBeam

    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    component = 5
    variable = rot_z
  [../]
[]

[Materials]
  [./elasticity]
    type = ComputeElasticityBeam
    youngs_modulus = 2.60072400269
    poissons_ratio = 0.3
    shear_coefficient = 0.85
    block = 0

  [../]
  [./strain]
    type = ComputeIncrementalCurvedBeamStrain
    block = '0'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    area = 0.554256
    Ay = 0.0
    Az = 0.0
    Iy = 0.0141889
    Iz = 0.0141889

   #y_orientation = '0.0 1.0 0.0'
  [../]
  [./stress]
    type = ComputeCurvedBeamResultants
  [../]
[]

[Postprocessors]
  [./disp_x]
    type = PointValue
    point = '4.0 0.0 0.0'
    variable = disp_x
  [../]
  [./disp_y]
    type = PointValue
    point = '4.0 0.0 0.0'
    variable = disp_y
  [../]
[]

[Outputs]
  exodus = true
[]
